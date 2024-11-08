import codeanticode.syphon.*;
import processing.video.*;

SyphonServer server;
ArrayList<File> arquivos;
int indiceAtual = 0;
PImage img;
Movie video;
String pasta = "/Users/helo/Desktop/FOTOS SPRITE"; // Caminho para sua pasta

int duracao = 5000; // Duração de cada mídia em milissegundos (5 segundos)
int tempoAnterior = 0; // Marca o último tempo em que a mídia foi trocada

void setup() {
  size(1920, 1080, P2D); // Resolução configurada para 1080x1920 (retrato)
  server = new SyphonServer(this, "Processing Syphon Output");
  atualizarListaArquivos(); // Carrega a lista de arquivos no início
  carregarArquivoAtual();
}

void draw() {
  background(0, 0, 0, 0); // Define o fundo como transparente

  // Exibe imagem ou vídeo conforme o tipo do arquivo atual, centralizado e sem redimensionamento
  if (img != null) {
    imageMode(CENTER);
    image(img, width / 2, height / 2); // Exibe no tamanho original, centralizado
  } else if (video != null) {
    imageMode(CENTER);
    image(video, width / 2, height / 2); // Exibe no tamanho original, centralizado
  }

  // Envia a tela atual para o Syphon
  server.sendScreen();

  // Verifica se já passaram 5 segundos para trocar de mídia
  if (millis() - tempoAnterior > duracao) {
    indiceAtual++;
    if (indiceAtual >= arquivos.size()) {
      // Atualiza a lista de arquivos ao final de cada loop
      atualizarListaArquivos();
      indiceAtual = 0; // Reinicia o índice para o próximo loop
    }
    carregarArquivoAtual();
    tempoAnterior = millis(); // Reinicia o temporizador
  }
}

// Função para atualizar a lista de arquivos da pasta
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

// Carrega o próximo arquivo (imagem ou vídeo)
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

// Evento chamado para atualizar os frames do vídeo
void movieEvent(Movie m) {
  m.read();
}
