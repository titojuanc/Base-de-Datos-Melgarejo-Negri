function cambiarColor(){
    console.log("Entré");

    if (document.getElementById('circulo').style.backgroundColor == 'gray'){
        document.getElementById('circulo').style.backgroundColor='red';
    }
    else{
        document.getElementById('circulo').style.backgroundColor='gray';
    }
}