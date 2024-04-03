//KNOB
//Definisce un array di valori corrispondenti ai canali dei knobs connessi ad ardunio
int knobs[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
//Inizializza un array vuoto da riempire con i valori dei knobs
int ValueKnobs[16];
//Inizializza un array vuoto da riempiri con i valori dei knob in ritardo
int ValueKnobsDel[16];
//Inizializza un array vuoto da riempiri con i valori di ValueKnobs - ValueKnobsDel
int ValueKnobsDif[16];
//Inizializza un array vuoto da riempiri con i valori scalati da 0-1023 a 0-200
int ValueOutKnobs[16];


void setup() {

  //inizializzo la porta seriale e decido la velocità (9600)
  Serial.begin(9600);

}

void loop() {

  //KNOB
  for (int i = 0; i < 16; i++) {

    ValueKnobs[i] = analogRead(knobs[i]); //I valori di tensione vengono passati all'array ValueKnobs attraverso analogRead
                                          //impostando attraverso knobs[i] i canali analogici di arduino
    
    ValueKnobsDif[i] = abs(ValueKnobs[i] - ValueKnobsDel[i]);//differenza tra i valori attuali e valori in ritardo
    ValueKnobsDel[i] = ValueKnobs[i];//calcola i valori in ritardo

    if (ValueKnobsDif[i] > 0) {
      ValueOutKnobs[i] = map(ValueKnobs[i], 0, 1023, 0, 200);//scala i valori da 0-1023 a 0-200

      delay(20);//aspetta 20 millesimi di secondo
      Serial.write(210 + i);//invia attraverso la porta seriale il "nome del knob"
      Serial.write(ValueOutKnobs[i]);//invia attraverso la porta seriale i valori tra 0 e 200 del knobs
      
    }
  }
//Serial.println(ValueKnobs[0]);
}
