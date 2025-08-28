# Script de diagnóstico para AFIP WSAA
Write-Host "=== DIAGNÓSTICO AFIP WSAA ===" -ForegroundColor Green

# 1. Verificar archivos de certificado
Write-Host "`n1. Verificando certificados..." -ForegroundColor Yellow
if (Test-Path "certificado.crt") {
    Write-Host "✓ certificado.crt existe"
    try {
        $certInfo = openssl x509 -in certificado.crt -text -noout | findstr "Not After"
        Write-Host "✓ Certificado válido: $certInfo"
    } catch {
        Write-Host "✗ Error al leer certificado: $($_.Exception.Message)"
    }
} else {
    Write-Host "✗ certificado.crt NO encontrado"
}

if (Test-Path "private.key") {
    Write-Host "✓ private.key existe"
    try {
        $keyCheck = openssl rsa -in private.key -check -noout 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Clave privada válida"
        } else {
            Write-Host "✗ Error en clave privada: $keyCheck"
        }
    } catch {
        Write-Host "✗ Error al verificar clave privada: $($_.Exception.Message)"
    }
} else {
    Write-Host "✗ private.key NO encontrado"
}

# 2. Verificar OpenSSL
Write-Host "`n2. Verificando OpenSSL..." -ForegroundColor Yellow
try {
    $opensslVersion = openssl version
    Write-Host "✓ OpenSSL disponible: $opensslVersion"
} catch {
    Write-Host "✗ OpenSSL no está instalado o no está en PATH"
    Write-Host "Instala OpenSSL y asegúrate de que esté en PATH"
    exit 1
}

# 3. Probar generación CMS
Write-Host "`n3. Probando generación CMS..." -ForegroundColor Yellow
$testSeq = Get-Date -UFormat "%Y%m%d%H%M%S"
$testXml = "test-$testSeq.xml"
$testCms = "test-$testSeq.cms"
$testB64 = "test-$testSeq.b64"

try {
    # Crear XML de prueba
    "<test>Prueba CMS $testSeq</test>" | Out-File $testXml -Encoding ASCII
    
    # Comando OpenSSL
    $opensslCmd = "openssl cms -sign -in `"$testXml`" -signer certificado.crt -inkey private.key -nodetach -outform der -out `"$testCms`""
    Write-Host "Ejecutando: $opensslCmd"
    
    $result = Invoke-Expression $opensslCmd 2>&1
    
    if ($LASTEXITCODE -eq 0 -and (Test-Path $testCms)) {
        Write-Host "✓ CMS generado exitosamente"
        Write-Host "Tamaño: $((Get-Item $testCms).Length) bytes"
        
        # Probar codificación base64
        $base64Cmd = "openssl base64 -in `"$testCms`" -e -out `"$testB64`""
        Write-Host "Ejecutando: $base64Cmd"
        
        Invoke-Expression $base64Cmd
        
        if (Test-Path $testB64) {
            Write-Host "✓ Codificación Base64 exitosa"
            $b64Content = Get-Content $testB64 -Raw
            if ($b64Content -and $b64Content.Trim().Length -gt 0) {
                Write-Host "✓ Contenido Base64 válido (longitud: $($b64Content.Trim().Length))"
            } else {
                Write-Host "✗ Contenido Base64 vacío"
            }
        } else {
            Write-Host "✗ Error en codificación Base64"
        }
    } else {
        Write-Host "✗ Error generando CMS:"
        Write-Host $result
        Write-Host "Exit code: $LASTEXITCODE"
    }
} catch {
    Write-Host "✗ Excepción en generación CMS: $($_.Exception.Message)"
} finally {
    # Limpiar archivos de prueba
    Remove-Item $testXml -ErrorAction SilentlyContinue
    Remove-Item $testCms -ErrorAction SilentlyContinue
    Remove-Item $testB64 -ErrorAction SilentlyContinue
}

# 4. Verificar conectividad AFIP
Write-Host "`n4. Verificando conectividad AFIP..." -ForegroundColor Yellow
try {
    $connection = Test-NetConnection wsaa.afip.gov.ar -Port 443 -InformationLevel Quiet
    if ($connection) {
        Write-Host "✓ Conexión a wsaa.afip.gov.ar:443 exitosa"
    } else {
        Write-Host "✗ No se puede conectar a wsaa.afip.gov.ar:443"
    }
} catch {
    Write-Host "✗ Error de conectividad: $($_.Exception.Message)"
}

# 5. Verificar WSDL
Write-Host "`n5. Verificando WSDL..." -ForegroundColor Yellow
try {
    $wsdlResponse = Invoke-WebRequest -Uri "https://wsaa.afip.gov.ar/ws/services/LoginCms?WSDL" -UseBasicParsing -TimeoutSec 30
    Write-Host "✓ WSDL accesible (Status: $($wsdlResponse.StatusCode))"
    
    if ($wsdlResponse.Content -like "*loginCms*") {
        Write-Host "✓ WSDL contiene método loginCms"
    } else {
        Write-Host "⚠ WSDL no contiene método loginCms esperado"
    }
} catch {
    Write-Host "✗ Error accediendo WSDL: $($_.Exception.Message)"
}

# 6. Probar creación de proxy
Write-Host "`n6. Probando creación de proxy..." -ForegroundColor Yellow
try {
    $wsaa = New-WebServiceProxy -Uri "https://wsaa.afip.gov.ar/ws/services/LoginCms?WSDL" -ErrorAction Stop
    Write-Host "✓ Proxy creado exitosamente"
    
    $methods = $wsaa | Get-Member -MemberType Method | Where-Object Name -like "*loginCms*"
    if ($methods) {
        Write-Host "✓ Método loginCms disponible"
    } else {
        Write-Host "✗ Método loginCms NO disponible"
    }
} catch {
    Write-Host "✗ Error creando proxy: $($_.Exception.Message)"
}

Write-Host "`n=== FIN DIAGNÓSTICO ===" -ForegroundColor Green
Write-Host "Si todos los pasos anteriores son exitosos, el problema puede ser temporal del servidor AFIP" -ForegroundColor Cyan