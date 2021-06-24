New-Item -Path $PSScriptRoot -Name "temp" -ItemType "directory" -Force

docker run --rm -v "${PSScriptRoot}:/local" openapitools/openapi-generator-cli generate -i /local/apis/order-api.yaml -g aspnetcore -c /local/config.yaml -o /local/temp 

Copy-Item -Path "${PSScriptRoot}\temp\src\*" -Destination "${PSSCriptRoot}\..\src" -Recurse -Force

Remove-Item -Path "${PSScriptRoot}\temp" -Recurse
