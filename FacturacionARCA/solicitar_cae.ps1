$xmlFile = Get-Content '#colocar aqui la direccion local de la carpeta FacturacionARCA y borrar este comentario\solicitud_cae.xml' -Raw
$url = 'https://servicios1.afip.gov.ar/wsfev1/service.asmx'
$response = Invoke-WebRequest -Uri $url -Method Post -Body $xmlFile -ContentType 'text/xml'
$response.Content | Out-File '#colocar aqui la direccion local de la carpeta FacturacionARCA y borrar este comentario\respuesta_cae.xml'
