<?php
session_start();
$_SESSION["ventana"] = "aboutUs";
require_once("navBar.php");
include_once("cabecera.php");

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Document</title>
</head>
<body>
    <fieldset class="formulario" style="width:750px">
    Óptica Maguilla es un proyecto creado por un equipo de 4 estudiantes del Grado de Ingeniería del Software para la asignatura
    IISSI 2.
    <br><br>
    El objetivo es la creación de una web sobre una base de datos previamente creada, que permite la gestión de diversos elementos
    relacionados con un negocio de optometría, esto es: productos, clientes, franquicias, encargos y ofertas

    </fieldset>
    <?php include_once("pie.php");?>
</body>
</html>