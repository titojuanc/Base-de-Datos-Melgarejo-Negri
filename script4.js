function agregarElemento(){
    let elemento = $('#elemento').val()
    let div = document.createElement("div")
    div.innerHTML = `<p id=${elemento}>${elemento}</p> <button onclick="eliminarProducto('${elemento}')">Elminar</button>`
    $('#lista').append(div)
}

function elminarProducto(elemento){
    
}