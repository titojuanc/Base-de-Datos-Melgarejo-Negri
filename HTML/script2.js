function verificacion(){
    let check = true;
    let letras = ['a', 'b', 'c', 'd', 'e', 'f']
    let valor = document.getElementById('campo').value; 
        if (valor[0] == '#') {
            if(valor.length !=7 ){
                alert("Ponelo bien gil de goma")
            }
            else{
                for (let i =1; i<valor.length ; i++){
                    if((valor[i]<=9 && valor[i]>=0) || letras.includes(valor[i].toLowerCase()) ){
                        continue;    
                    }
                    else{
                        alert("Alto bobo ponelo bien gil")
                        check=false
                        break;
                    }
                }
                if(check){cambiarColor(valor)}
            }
        }
        else{
            alert("bobo")
        }
}

function cambiarColor(valor){
    document.getElementById('circulo').style.backgroundColor = valor;
}
