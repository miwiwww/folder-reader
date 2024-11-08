import codeanticode.syphon.*;
import processing.video.*;

SyphonServer server;
ArrayList<File> arquivos;
int indiceAtual = 0;
PImage img;
Movie video;
String pasta = "/Users/Desktop/folder"; // Write your folder path here

int duracao = 5000; // mídia duration milisseconds (5s)
int tempoAnterior = 0;

void setup() {
  size(1920, 1080, P2D); // Resolution
  server = new SyphonServer(this, "Processing Syphon Output");
  atualizarListaArquivos(); // UploadFolder
  carregarArquivoAtual();
}

void draw() {
  background(0, 0, 0, 0); // Define o fundo como transparente

  // Image without Scalling
  if (img != null) {
    imageMode(CENTER);
    image(img, width / 2, height / 2); // original size, center
  } else if (video != null) {
    imageMode(CENTER);
    image(video, width / 2, height / 2); // original size, center
  }

  // Send to Syphon
  server.sendScreen();

  // Duration
  if (millis() - tempoAnterior > duracao) {
    indiceAtual++;
    if (indiceAtual >= arquivos.size()) {
      // Refresh Folder
      atualizarListaArquivos();
      indiceAtual = 0; // Reinicia o índice para o próximo loop
    }
    carregarArquivoAtual();
    tempoAnterior = millis(); // Reinicia o temporizador
  }
}

// Refresh Folder
void atualizarListaArquivos() {
  arquivos = new ArrayList<File>();
  File diretorio = new File(pasta);
  for (File file : diretorio.listFiles()) {
    String nomeArquivo = file.getName().toLowerCase();
    if (nomeArquivo.endsWith(".jpg") || nomeArquivo.endsWith(".jpeg") ||
        nomeArquivo.endsWith(".png") || nomeArquivo.endsWith(".bmp") ||
        nomeArquivo.endsWith(".tiff") || nomeArquivo.endsWith(".mp4") ||
        nomeArquivo.endsWith(".avi")) {
      arquivos.add(file);
    }
  }
}

// Upload Next File
void carregarArquivoAtual() {
  if (indiceAtual < arquivos.size()) {
    File arquivoAtual = arquivos.get(indiceAtual);
    String nomeArquivo = arquivoAtual.getName().toLowerCase();

    if (nomeArquivo.endsWith(".mp4") || nomeArquivo.endsWith(".avi")) {
      video = new Movie(this, arquivoAtual.getAbsolutePath());
      video.loop();
      img = null; // Limpa imagem
    } else {
      img = loadImage(arquivoAtual.getAbsolutePath());
      video = null; // Limpa vídeo
    }
  }
}

// Refresh video frames
void movieEvent(Movie m) {
  m.read();
}
