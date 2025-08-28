# 📊 ERP en Excel con integración a ARCA (AFIP)

[![Estado](https://img.shields.io/badge/status-activo-brightgreen)](#) [![Excel](https://img.shields.io/badge/Excel-VBA-green?logo=microsoft-excel)](#) [![AFIP](https://img.shields.io/badge/AFIP-ARCA-blue)](https://www.afip.gob.ar/ws/) [![Licencia](https://img.shields.io/badge/licencia-MIT-yellow)](#)

Un **ERP desarrollado en Excel con VBA** que automatiza **presupuestación, facturación y gestión comercial**.  
Se integra con **ARCA (AFIP)** para la emisión de comprobantes electrónicos de manera automática.  
Ideal para **negocios, empresas, monotributistas y emprendedores**.

---

## ✨ Funcionalidades principales

- ✅ Gestión de productos con múltiples listas de precios  
- ✅ Registro de clientes y facturación  
- ✅ Emisión de **Facturas (A y B)**, **Notas de crédito**, **Remitos** y **Presupuestos**  
- ✅ Registro histórico de operaciones  
- ✅ Integración con **ARCA/AFIP** para CAE, firmas, tokens y vencimientos  
- ✅ Código **ampliable y escalable**, documentado para personalizarlo

---

## ⚙️ Instalación y configuración

### 1. Descargar el proyecto
Cloná el repositorio o descargá el ZIP:

```bash
git clone https://github.com/USUARIO/NOMBRE_REPO.git
```

Abrí el archivo Excel incluido en la carpeta.

---

### 2. Configuración de VBA
- Dentro del Excel abrí el editor de VBA (Alt + F11).  
- Buscá los bloques comentados que indican **dónde colocar los directorios locales** (paths).  
- Editá esos paths para apuntar a las carpetas en tu máquina.  
- El código VBA está documentado y comentado para facilitar modificaciones; revisá los comentarios antes de cambiar lógica.

---

### 3. Configuración de scripts de facturación (PowerShell)
- En la carpeta `FacturacionARCA` están los scripts `.ps1` que manejan la comunicación con ARCA (solicitud de CAE, manejo de tokens, firmas y control de fechas).  
- Editá en esos `.ps1` los directorios locales y valores de configuración (rutas a archivos, logs, etc.).  
- Asegurate de tener permisos para ejecutar scripts PowerShell en tu máquina (`Set-ExecutionPolicy` si hace falta, con precaución).

---

### 4. Certificados AFIP (ARCA)
Para habilitar la facturación electrónica necesitás:

1. Generar un **Key** y un **Certificado** según la documentación de ARCA.  
2. Colocarlos dentro de la carpeta `FacturacionARCA` (o en la ruta que hayas configurado en los `.ps1`).  
3. Seguir los pasos de la documentación oficial para registrar y usar los certificados.

> Si **no** vas a emitir facturas electrónicas (solo presupuestos, clientes, listados), **no es necesario** crear certificados; únicamente configurá los directorios en el VBA.

---

## ▶️ Uso

- Configurá los directorios en el código VBA y en los scripts PowerShell (`FacturacionARCA`).  
- Abrí el Excel y trabajá con las hojas/menús que incluye el ERP (productos, clientes, presupuestos, facturación).  
- Para emitir facturas electrónicas: asegurate de que los certificados y credenciales estén en su lugar dentro de `FacturacionARCA` y que los scripts se ejecuten correctamente desde Excel (o manualmente si necesitás probar).

---

## 📖 Documentación y recursos de ayuda

- 📄 **Documentación oficial ARCA (AFIP):**  
  https://www.afip.gob.ar/ws/

- 🎥 **Videos explicativos (YouTube):**  
  - https://www.youtube.com/watch?v=3fKJOhdEumU&list=LL&index=53&t=891s&ab_channel=MaximoBatallan  
  - https://www.youtube.com/watch?v=prMg0tRX5pA&list=LL&index=52&t=266s&ab_channel=MaximoBatallan

---

## 🤝 Contribución
Este proyecto es abierto y ampliable. Podés:  
- Reportar **issues**.  
- Proponer **mejoras**.  
- Crear nuevas funcionalidades (reportes, integraciones, UI mejorada).

---

## 📜 Licencia
Distribuido bajo licencia **MIT**.  
Podés usarlo, modificarlo y compartirlo libremente.

---
