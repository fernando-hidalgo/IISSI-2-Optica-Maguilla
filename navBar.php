<div class = "navBar">
    <ul>
        <li><a onclick="cliente()"><img id="logo"src="images/logo.png" alt="Optica Maguilla"></a></li>
        <li><a id="link" <?php if($_SESSION["ventana"] == "clientes") echo 'class="active"'?> onclick="cliente()">Clientes</a></li>
        <li><a id="link" <?php if($_SESSION["ventana"] == "ofertas") echo 'class="active"'?>onclick="ofertas()" >Ofertas</a></li>
        <li><a id="link" <?php if($_SESSION["ventana"] == "productos") echo 'class="active"'?>onclick="productos()">Productos</a></li>
        <li><a id="link" <?php if($_SESSION["ventana"] == "encargos") echo 'class="active"'?>onclick="encargos()">Encargos</a></li>
        <li><a id="link" <?php if($_SESSION["ventana"] == "franquicias") echo 'class="active"'?>onclick="franquicias()">Franquicias</a></li>
        <li id="liBoutUs"><a id="link" style="float:right;" <?php if($_SESSION["ventana"] == "aboutUs") echo 'class="active"'?>onclick="aboutUs()">Sobre Nosotros</a></li>
    </ul>
</div>

<script>
    function cliente(){
        location.href = "paginacion_clientes.php";
    }
    function ofertas(){
        location.href = "ofertas.php"; 
    }
    function productos(){
        location.href = "paginacion_productos.php"; 
    }
    function encargos(){
        location.href = "paginacion_encargos.php"; 
    }
    function franquicias(){
        location.href = "paginacion_franquicia.php"; 
    }
    function aboutUs(){
        location.href = "about.php"; 
    }
</script>