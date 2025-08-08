
function mostrarTabla(){
    let errores = [];
    if($('#nombre').val().includes(' ') || $('#nombre').val().length == 0){
        errores.push("Hay un error en el nombre. No debe tener espacios ni estar vacío")
    }
    if($('#apellido').val().includes(' ') || $('#apellido').val().length == 0){
        errores.push("Hay un error en el apellido. No debe tener espacios ni estar vacío")
    }
    if($('#contrasenia').val().includes($('#nombre').val()) || $('#contrasenia').val().includes($('#apellido').val()) || $('#contrasenia').val().length<6 || $('#contrasenia').val().length == 0){
        errores.push("Hay un error en la contraseña. Debe tener 6 caracteres o más y no debe contener el nombre o el apellido. No debe estar vacía")
    }
    if($('#edad').val() < 10 && $('#edad').val()>100 || $('#edad').val().length == 0){
        errores.push("Hay un error en la edad. Debe introducir una edad válida y no estar vacía.")
    }
    if($('#telefono').val().length !=10 && $('#telefono').val(0)==1 && $('#telefono').val(1)==1 || $('#telefono').val().length == 0){
        errores.push("Hay un error en el teléfono. Debe introducir un número válido y no debe estar vacío.")
    }

    if(errores.length == 0){
        console.log("entré")
        let valorN = document.createElement("p")
        valorN.innerText = "nombre:" + $('#nombre').val();
        $('#tabla').append(valorN)
        let valorA = document.createElement("p")
        valorA.innerText = "apellido:" + $('#apellido').val();
        $('#tabla').append(valorA)
        let valorE = document.createElement("p")
        valorE.innerText = "edad:" + $('#edad').val();
        $('#tabla').append(valorE)
        let valorT = document.createElement("p")
        valorT.innerText = "telefono:" + $('#telefono').val();
        $('#tabla').append(valorT)
        let valorC = document.createElement("p")
        valorC.innerText = "contraseña:" + $('#contrasenia').val();
        $('#tabla').append(valorC)   
    }
    else{
        alert(errores)
    }
}