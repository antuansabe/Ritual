#!/usr/bin/env python3
"""
Fix HTML formatting for legal docs
"""

# Read the MD files and create proper HTML manually
privacy_html = """<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Política de Privacidad - Ritmia</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-top: 30px;
        }
        h2 {
            color: #34495e;
            margin-top: 25px;
            margin-bottom: 15px;
        }
        p {
            margin-bottom: 15px;
            text-align: justify;
        }
        ul {
            margin-bottom: 15px;
            padding-left: 20px;
        }
        li {
            margin-bottom: 8px;
        }
        strong {
            color: #2c3e50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f8f9fa;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <h1>Política de Privacidad – Ritmia Fitness App</h1>
    
    <p><strong>Última actualización:</strong> 19 julio 2025<br>
    <strong>Versión:</strong> 1.0</p>

    <h2>1. ¿Quiénes somos?</h2>
    <p>Ritmia Fitness App («Ritmia», «nosotros») es desarrollada por Antonio Fernández (México). Para cualquier consulta:<br>
    Correo: legal@ritmia.app</p>

    <h2>2. Datos que recopilamos</h2>
    <table>
        <tr><th>Categoría</th><th>Detalle</th><th>Base legal*</th></tr>
        <tr><td>Identificadores</td><td>Apple ID (email seudonimizado), ID de usuario interno</td><td>Ejecución del servicio</td></tr>
        <tr><td>Datos de actividad</td><td>Tipos de entrenamiento, duración, calorías estimadas</td><td>Ejecución del servicio</td></tr>
        <tr><td>Preferencias</td><td>Objetivo semanal, tema claro/oscuro, idioma</td><td>Interés legítimo</td></tr>
        <tr><td>Diagnóstico</td><td>Logs de fallo y métricas anónimas (Crashlytics)</td><td>Interés legítimo</td></tr>
    </table>
    <p>* Art. 6 (1) b y f RGPD; §5 LFPDPPP (México). Los datos de salud no se comparten con terceros.</p>

    <h2>3. Cómo utilizamos los datos</h2>
    <ul>
        <li>Sincronizar entrenamientos entre dispositivos vía iCloud / CloudKit</li>
        <li>Calcular progreso y mostrar rachas semanales</li>
        <li>Enviar notificaciones motivacionales (opt-in)</li>
        <li>Mejorar estabilidad con reportes de caída anónimos</li>
    </ul>

    <h2>4. Almacenamiento y seguridad</h2>
    <ul>
        <li>Datos sensibles cifrados con AES-256 y protegidos por FileProtection.complete</li>
        <li>Claves en Keychain accesibles solo cuando el dispositivo está desbloqueado</li>
        <li>El historial se guarda en la base privada de iCloud del usuario; Ritmia no tiene acceso directo</li>
    </ul>

    <h2>5. Retención y eliminación</h2>
    <ul>
        <li>Entrenamientos se conservan hasta que el usuario los borre o elimine su cuenta</li>
        <li>La opción «Eliminar cuenta y datos» borra de Keychain y de iCloud (Record Zone) en menos de 30 días</li>
    </ul>

    <h2>6. Derechos del usuario</h2>
    <p>Puedes ejercer acceso, rectificación, cancelación u oposición escribiendo a privacy@ritmia.app. Para usuarios UE/EEE: también derecho a portabilidad y a presentar reclamación ante tu autoridad local.</p>

    <h2>7. Transferencias internacionales</h2>
    <p>Los servidores de Apple iCloud pueden estar fuera de tu país. Apple se acoge a cláusulas contractuales tipo (SCC) y al Marco de Privacidad de Datos UE-EE. UU.</p>

    <h2>8. Cambios</h2>
    <p>Notificaremos en la app y actualizaremos la fecha al publicar nuevas versiones.</p>
</body>
</html>"""

terms_html = """<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Términos de Servicio - Ritmia</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-top: 30px;
        }
        h2 {
            color: #34495e;
            margin-top: 25px;
            margin-bottom: 15px;
        }
        p {
            margin-bottom: 15px;
            text-align: justify;
        }
        ul {
            margin-bottom: 15px;
            padding-left: 20px;
        }
        li {
            margin-bottom: 8px;
        }
        strong {
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <h1>Términos de Servicio – Ritmia Fitness App</h1>
    
    <p><strong>Última actualización:</strong> 19 julio 2025</p>

    <h2>1. Aceptación</h2>
    <p>Al crear una cuenta o usar Ritmia, aceptas estos términos y la Política de Privacidad.</p>

    <h2>2. Uso permitido</h2>
    <ul>
        <li>Solo mayores de 16 años o con consentimiento paterno.</li>
        <li>Uso personal y no comercial; está prohibido revender métricas o contenido.</li>
    </ul>

    <h2>3. No es asesoramiento médico</h2>
    <p>Ritmia proporciona estimaciones y mensajes motivacionales sin sustituir consejo médico profesional. Consulta a un médico antes de iniciar un programa de ejercicio.</p>

    <h2>4. Licencia</h2>
    <p>Se te otorga una licencia revocable, no exclusiva, intransferible para instalar y usar la app en dispositivos iOS vinculados a tu Apple ID.</p>

    <h2>5. Propiedad intelectual</h2>
    <p>Todos los derechos sobre el código, nombre, logotipo y recursos son de Antonio Fernández. Iconos de entrenamientos se usan bajo licencia SF Symbols / Apple Human Interface Guidelines.</p>

    <h2>6. Contenido generado por el usuario</h2>
    <p>Eres responsable de la veracidad de tus entrenamientos y comentarios. Nos reservas un derecho no exclusivo para procesarlos con el fin de prestar el servicio.</p>

    <h2>7. Suspensión y terminación</h2>
    <p>Podemos suspender tu acceso si incumples estos términos o abusas de la API de iCloud. Puedes eliminar tu cuenta en cualquier momento desde Perfil › Eliminar cuenta y datos.</p>

    <h2>8. Limitación de responsabilidad</h2>
    <p>Ritmia se ofrece «tal cual». No respondemos por pérdidas indirectas. Nuestra responsabilidad agregada no excederá el importe pagado por la app (actualmente gratis).</p>

    <h2>9. Ley aplicable y jurisdicción</h2>
    <ul>
        <li><strong>Usuarios de América:</strong> leyes de los Estados Unidos Mexicanos.</li>
        <li><strong>Usuarios UE:</strong> se aplica el Reglamento (UE) 2019/1150 y tu ley nacional imperativa.</li>
    </ul>
    <p>Cualquier disputa será dirimida en los tribunales de Ciudad de México, salvo normas imperativas.</p>

    <h2>10. Cambios en los términos</h2>
    <p>Publicaremos aviso dentro de la app con 7 días de anticipación. El uso continuado implica aceptación.</p>
</body>
</html>"""

# Write the clean HTML files
with open('fit-app/Legal/PrivacyPolicy.html', 'w', encoding='utf-8') as f:
    f.write(privacy_html)

with open('fit-app/Legal/TermsOfService.html', 'w', encoding='utf-8') as f:
    f.write(terms_html)

print("✅ Clean HTML files generated successfully!")
print("✅ No lorem ipsum - Ready for production!")