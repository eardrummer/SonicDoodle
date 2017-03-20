
void playVideosetup() {
  myMovie = new Movie(this, "Letter Explosion_2.mp4");
  myMovie.play();
}

void movieEvent(Movie m) {
  m.read();
}
  