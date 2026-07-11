console.log("CAMERA.JS CARGADO");

async function iniciarCamara() {

    console.log("Entró a iniciarCamara()");

    const video = document.getElementById("video");

    if (!video) {
        console.log("No existe el elemento video");
        return;
    }

    try {

        console.log("Solicitando cámara...");

        const stream = await navigator.mediaDevices.getUserMedia({
            video: true,
            audio: false
        });

        console.log("Cámara concedida");

        video.srcObject = stream;

        await video.play();

        console.log("Video reproduciéndose");

    } catch (error) {

        console.error(error);

    }

}

document.addEventListener("DOMContentLoaded", iniciarCamara);
document.addEventListener("turbo:load", iniciarCamara);