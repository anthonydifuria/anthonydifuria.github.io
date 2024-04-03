function copiaTesto() {
    /* Seleziona l'elemento contenente il codice */
    var codice = document.getElementById("codiceTesto");

    /* Seleziona il testo contenuto nell'elemento */
    var selezione = window.getSelection();
    var range = document.createRange();
    range.selectNodeContents(codice);
    selezione.removeAllRanges();
    selezione.addRange(range);

    /* Copia il testo selezionato */
    document.execCommand("copy");

    /* Deseleziona il testo */
    selezione.removeAllRanges();
}
