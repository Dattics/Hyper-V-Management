# Agregar host de Hyper-V a listado de hosts del equipo, es opcional para ingresar el FQDN en caso que no se dé por DNS
# Para este ejemplo, el host Hyper-V será 192.168.1.1 y el FQDN será ejemplo.dattics.corp
Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.1.1 ejemplo.dattics.corp"

# El perfil de la red a la que estamos conectados debe ser privado (no funciona con redes públicas)
Get-NetConnectionProfile
# El InterfaceAlias debe corresponder al que encontremos en el comando anterior, puede variar de acuerdo 
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private

# Habilitar administración remota
Enable-PSRemoting

# Validar si se cuenta con permisos de delegación de contraseñas, se puede habiliar para todo el dominio para facilitar el acceso
Get-WSManCredSSP
Enable-WSManCredSSP -Role Client -DelegateComputer "*.dattics.corp"

# Agregar hosts de confianza, se puede habiliar para todo el dominio para facilitar el acceso
Get-Item -Path WSMan:\localhost\Client\TrustedHosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "*.dattics.corp"

# Agregar credenciales para cada host de Hyper-V
cmdkey /list
cmdkey /add:ejemplo.dattics.copr /user:Administrator /pass:ContraseñaAdmin

# Se puede validar acceso remoto a PowerShell para administración
Enter-PSSession -ComputerName ejemplo.dattics.corp
Get-VM

# Si lo anterior funciona, ya se puede iniciar administración con Hyper-V Manager en Windows 10 Pro o superior
