function agregarElemento(){
    console.log("entré");
    let elemento = $('#elemento').val();
    let div = document.createElement('div');
    let btn = document.createElement('button');
    div.setAttribute('id', elemento)    
    btn.innerHTML = `Elminar`
    div.innerHTML = `<p>${elemento}</p>`
    $('#lista').append(div);
    btn.addEventListener("click", ()=>{
        div.remove();
    } )
    div.append(btn);

}
