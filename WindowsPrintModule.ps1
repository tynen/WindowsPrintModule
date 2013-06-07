# This module is written by Robert Sinrud (http://whenindoubtbacon.wordpress.com/)
# It is freely available
#
#
#
#remove specific printer driver
function Remove-PrintDriver {
	param(
		[Parameter(ValueFromPipeline=$true,Mandatory=$true,Position=0)]
		$driverName
	)

	Set-Location c:\windows\system32\printing_admin_scripts\en-us
	$cmd = "cscript prndrvr.vbs -d -m " + '"' + $drivername + '"' + " -v 3 -e" + ' "' + "Windows x64" + '"' 
	Invoke-Expression $cmd

}


#Collecting locally installed drivers 
function Get-PrintDriver {
	param(
		[String]$Name
	)
	$localDrivers = @() 
	foreach ($driver in (Get-WmiObject Win32_PrinterDriver)){ 
		$localDrivers += @(($driver.name -split ",")[0]) 
	} 
	if(!$Name){
		return $localDrivers
	}else{
		$value = $localDrivers | Where-Object {$_ -like "*$name*"}
		return $value
	}
}

#remove all unused print drivers
function Remove-UnusedPrintDrivers {
	param(
	)

	Set-Location c:\windows\system32\printing_admin_scripts\en-us
	Invoke-Expression "cscript prndrvr.vbs -x"
	
}

#delete printer
function Remove-Printer {
	param(
		[Parameter(ValueFromPipeline=$true,Mandatory=$true,Position=0)]
		$printerName,
		
		[Parameter(ValueFromPipeline=$false,Mandatory=$false,Position=1)]
		[Switch]$removeDriver = $true
	)
	
	#/dd Deletes a printer driver.
	#/dn Deletes a network printer connection.
	#/n Name of the printer
	# if($removeDriver){$driver = "/dd"}
	$cmd =  "rundll32 printui.dll,PrintUIEntry /dn /n""$printerName"""
	Invoke-Expression $cmd


}

#enumerate installed network printers	
function Get-Printer {
<#
		.SYNOPSIS
			Get-Printer lists all printers installed.

		.DESCRIPTION
			This function calls the Win32_Printer WMI object and pulls all installed printers. The default value returned is the Device ID.

		.PARAMETER  ParameterA
			-Network $true
			The network parameter sets wether you want network printers or all printers


		.EXAMPLE
			Get-Printer -Network $true

		.EXAMPLE
			Get-Printer

		.INPUTS
			System.String,System.Int32

		.OUTPUTS
			System.String


	#>
	param(
		[String]$Name,
		[Switch]$Network
	)
	if($Network){
		$cmd = "Get-WmiObject Win32_Printer -EnableAllPrivileges -Filter network=true"
		}else{$cmd = "Get-WmiObject Win32_Printer -EnableAllPrivileges"}
	
	[array] $printers = invoke-expression $cmd
	if(!$name){
		return $printers
	}else{
		$result = $printers | Where-Object {$_.DeviceID -like "*$Name*"}
		return $result
		}
}

