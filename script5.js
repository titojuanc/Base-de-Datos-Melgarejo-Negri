async function generarImg(){
    let url = "https://dog.ceo/api/breeds/image/random";
    let rta = await fetch(url);
    let res = await rta.json();
    $('#fotito').attr("src", res.message)
    console.log(res);
}

async function generarFacto(){
    let url = "https://dogapi.dog/api/v2/facts";
    let respuesta = await (await fetch(url)).json();
    console.log(respuesta)
    let res = await respuesta.data[0].attributes.body;  
    await console.log(res);
    $('#dato').text(res)
}