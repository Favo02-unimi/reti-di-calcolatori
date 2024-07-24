#import "@preview/gentle-clues:0.8.0": *
#import "@preview/cetz:0.2.2"
#import "@preview/codly:0.2.0": *
#import "@preview/equate:0.2.0": equate

// pdf metadata
#set document(
  title: "Reti di calcolatori",
  author: ("Luca Favini")
)

// codly setup
#show: codly-init.with()
#codly(
  languages: (java: (name: "Java", color: maroon, icon: none)),
  zebra-color: white,
  stroke-width: 1.5pt,
  stroke-color: blue,
  enable-numbers: false
)

// evidenziare link
#show link: it => {
  if type(it.dest) != str {
    // link interni
    underline(it, stroke: 1.5pt + blue)
  }
  else {
    // link esterni
    underline(it, stroke: 1.5pt + red)
  }
}

// evidenziare link nell'indice
#show outline.entry: it => {
  underline(it, stroke: 1.5pt + blue)
}

// settings box colorati
#show: gentle-clues.with(breakable: true)

// settings equazioni
#show: equate.with(breakable: true)

// box colorati
#let nota(body) = { info(title: "Nota")[#body] }
#let attenzione(body) = { warning(title: "Attenzione")[#body] }
#let informalmente(body) = { conclusion(title: "Informalmente")[#body] }
#let dimostrazione(body) = { memo(title: "Dimostrazione")[#body] }

// testo matematico colorato
#let mg(body) = text(fill: olive, $#body$)
#let mm(body) = text(fill: maroon, $#body$)
#let mo(body) = text(fill: orange, $#body$)
#let mr(body) = text(fill: red, $#body$)
#let mp(body) = text(fill: purple, $#body$)
#let mb(body) = text(fill: blue, $#body$)

// numerazione titoli
#set heading(numbering: "1.1.")

// pagina iniziale (titolo)
#page(align(left + horizon, block(width: 90%)[

  #text(3em)[*Reti di calcolatori*]\
  #text(1.5em)[Università degli studi di Milano - Informatica]

  #link("https://github.com/Favo02")[
    #text(1.5em, "Luca Favini")
  ]

  #text("Ultima modifica:")
  #datetime.today().display("[day]/[month]/[year]")
]))

#set par(linebreaks: "optimized")

// impostazioni pagine
#let numberingH(c)={
  return numbering(c.numbering,..counter(heading).at(c.location()))
}

#let currentH(level: 1)={
  let elems = query(selector(heading).after(here()))

  if elems.len() != 0 and elems.first().location().page() == here().page() {
    return [#numberingH(elems.first()) #elems.first().body]
  } else {
    elems = query(selector(heading).before(here()))
    if elems.len() != 0 {
      return [#numberingH(elems.last()) #elems.last().body]
    }
  }
  return ""
}

#set page(
  numbering: "1",
  number-align: bottom + right,
  header: [
    #set text(8pt)
    _Reti di calcolatori_
    #h(1fr)
    #context[_ #currentH() _]
  ],
  footer: [
    #set text(8pt)

    #context[
      _Luca Favini - #datetime.today().display("[day]/[month]/[year]")_
      #h(1fr)
      #text(12pt)[#counter(page).display("1")]
    ]
  ],
)

#heading(outlined: false, bookmarked: false, numbering: none, "Reti di calcolatori")

#heading(outlined: false, bookmarked: false, numbering: none, "Autori, Ringraziamenti e Licenza")

/ Autori: #link("https://github.com/Favo02")[Luca Favini] _(indice)_, #link("https://github.com/???")[???] _(chi li finirà per Settembre???)_
/ Ringraziamenti: #link("https://github.com/LucaCorra02")[Luca Corradini] _(appunti)_, #link("https://github.com/michelebolis")[Michele Bolis] _(appunti)_, #link("https://github.com/alsacchi")[Andrea Sacchi] _(revisione)_
/ Sorgente e Licenza: #link("https://github.com/Favo02/reti-di-calcolatori")[github.com/Favo02/reti-di-calcolatori] (#link("https://creativecommons.org/licenses/by/4.0/")[CC-BY-4.0])
/ Ultima modifica: #datetime.today().display("[day]/[month]/[year]")

#show outline.entry.where(
  level: 1
): it => {
  v(15pt, weak: true)
  strong(it)
}

// indice
#outline(
  title: "Indice",
  indent: auto
)

#pagebreak()

= Introduzione

== Cos'è una rete

=== Commutazione

È la scelta di un percorso (inteso come linea di ingresso-uscita) al fine di inviare un messaggio.

==== Commutazione di circuito

==== Commutazione di messaggio

Il messaggio viene inviato per intero sulla rete.

Svantaggi:
- Il messaggio può raggiungere grandi dimensioni
- Difficile gestione nei nodi (ordine di instradamento, precendenze tra i messaggi)
- Difficoltà nell'allocare memoria data la variabilità della dimensione
- Se corrotto va reinviato interamente

==== Commutazione di pacchetto

Il messaggio viene inviato tramite pacchetti di dimensione standard.

Svantaggi:
- È necessaria una decomposizione e poi ricomposizione del messaggio
- Intestazioni ripetute su ogni pacchetto
- Tempo di arrivo e ordine non predicibile

=== Tipologie di rete

- LAN
- MAN
- WAN

=== Topologie di rete

- Reti magliate
- Reti broadcast

=== Commutazione

- Di messaggio
- A pacchetto

=== Rete affidabile

Per garantire affidabilità di una trasmissione è necessario soddisfare tre proprietà:

- ogni pacchetto deve essere *corretto*
- garantire l'*ordine originale* dei pacchetti
- *assenza* di pacchetti *duplicati*

È possibile utilizzare due approcci garantire affidabilità:

- ogni *coppia di nodi* rende affidabile il link che li collega
- i *nodi agli estremi* rendeono affidabile l'intera trasmissione

== Composizione di una rete

=== Dispositivi di rete

Porte PISO (Parallel In Serial Our) / SIPO (Serial In Parallel Out)

==== Hub (livello 1)

#informalmente[
  Ripetitore stupido di quello che gli arriva da una porta a tutte le porte (broadcast)
]

==== Bridge (livello 2)

#informalmente[
  Separa tipicamente due domini di collisione (le collisioni possono comunque avvenire nelle singole aree). È intelligente ed ha una tabella di forwarding
]

#nota[
  Lavora in modo software
]

==== Switch (livello 2)

#informalmente[
  Ogni porta (interfaccia) ha un suo dominio di collisione. È intelligente ed ha una tabella di forwarding
]

Tabella di forwarding:
- riceve qualcosa
  - mittente
    - già in tabella: non succede nulla
    - non in tabella: aggiunge il suo MAC e la porta a cui è connesso
  - destinataorio:
    - già in tabella: manda il frame solo a quella porta
    - non in tabella: manda in flooding a tutte le porte tranne la sorgente

#attenzione[
  se un dispositivo non manda mai pacchetti (ma riceve e basta) non verrà mai associato il suo MAC alla sua porta
]

#nota[
  Lavora in modo hardware, molto più efficiente di un bridge
]

==== Router (livello 3)

Ogni nodo della rete è un *router*, collegati tra loro attraverso dei *link*. Ogni router ha al suo interno almeno un'*interfaccia di rete*, a sua volta composta da *due code* (buffer): una d'ingresso e una d'uscita.

Il router funziona grazie a tre processi:
- *scheduler*: si occupa di gestire quando e quali messaggi esaminare
- *interprete*: esamina i messaggi e li passa al processo di routing
- *routing*: determina in quale coda d'uscita mandare il pacchetto, attraverso la consultazione delle *tabelle di routing* (instradamento)

=== Mezzi trasmissivi (cavi)

- Rame/Coassiale/Telefono: $2 dot 10^8 space b p s$
- Fibra: $3 dot 10^8 space b p s$

== Regole di una rete: protocolli

Un protocollo è un algoritmo distribuito, che organizza la comunicazione tra entità:

- realizza le *macchine a stati finiti* che governano le entità
- impone una *serie di convenzioni* sui messaggi scambiati

=== Modello ISO/OSI

- Livello 1: Fisico
- Livello 2: Data link
- Livello 3: Rete
- Livello 4: Trasporto
- Livello 5: Sessione
- Livello 6: Presentazione
- Livello 7: Applicazione

#informalmente[
  Modello teorico non davvero usato
]

=== Stack TCP/IP

- Livello 1 (1+2 ISO/OSI): Data link
- Livello 2 (3 ISO/OSI): Rete
- Livello 3 (4 ISO/OSI): Trasporto
- Livello 4 (5+6+7 ISO/OSI): Applicazione

#informalmente[
  Standard de facto
]

== Unità di misura

Utilizzeremo soprattutto $s$ (secondi), $b$ (bit) e $B$ (byte), con relativi multipli:

- $T$ tera: $10^12$
- $G$ giga: $10^9$
- $M$ mega: $10^6$
- $K$ kilo: $10^3$
- $m$ milli: $10^(-3)$
- $mu$ micro: $10^(-6)$
- $n$ nano: $10^(-9)$

= Livello 2: Data Link _(Livello 1 TCP/IP)_

Unità: frame

#informalmente[
  Gestisce logicamente l'accesso al canale fisico (livello inferiore), evitando collisioni.
]

== Multiple Access Control (MAC)

#informalmente[
  Parte "bassa" del livello: gestice l'accesso fisico al canale
]

=== Tempi di trasmissione

Tempi di accesso/scrittura al canale fisico

==== Velocità di trasmissione $V_x$ (banda/bitrate)

Misurato in $b p s$ (bit per second)

#informalmente[
  Quanto velocemente si riesce ad "infilare" bit nel cavo
]

#nota[
  Il clock è limitato dalla larghezza di banda
]

==== Tempo di trasmissione $t_x$

#informalmente[
  Tempo che ci mettono i dati da mandare ad essere "inseriti" nel cavo
]

Misurato in $s$ (secondi):

$ t_x = N/V_x $

Dove $N$ è il numero di bit da inviare e $V_x$ è la banda (velocità di trasmissione) del cavo utilizzato

==== Velocità di propagazione $V_p$

Misurato in $m\/s$ (metri al secondo)

#informalmente[
  Velocità alla quale il segnale (elettrico o luce) si propaga nel cavo
]

==== Tempo di propagazione $t_p$

#informalmente[
  Tempo che ci mette il dato ad arrivare all'altra estremita del cavo
]

Misurato in $s$ (secondi):

$ t_p = L / V_p $

Dove $L$ è la lunghezza del cavo e $V_p$ è la velocità di propagazione

==== Rount trip time $R T T$

#informalmente[
  Tempo che ci mette il dato ad *andare* e *tornare* al mittente
]

Misurato in $s$ (secondi):

$ R T T = 2 t_p $

==== Retrasmission timeout $R T O$

#informalmente[
  Tempo prima di reinviare ancora un certo dato, tipicamente perchè non si è ricevuto un ACK
]

==== Efficienza della rete $U$

#informalmente[
  Quanto il canale è occupato, ovvero se stiamo continuamente "infilando" dati nel canale o stiamo aspettando tanto tempo per la propagazione
]

Misura adimensionale, tra $0$ e $1$:

$ U = t_x / (t_x + 2 t_p) $

#attenzione[
  Nei protocolli a finestra (con finestra $k$) diventa:
  $ U = k dot t_x / (t_x + 2 t_p) $
]

==== Jitter

#informalmente[
  Due pacchetti non possono metterci lo stesso tempo a viaggiare dato che la rete è complessa e possono accadere innumerevoli problemi. Il jitter è la varianza tra i vari tempi di trasmissione
]

==== Latenza

Tempo totale impegato dal pacchetto per essere spedito e ricevuto.

$ T = t_"coda" + t_"elaborazione" + t_"trasmissione" + t_"propagazione" $

- $t_"coda"$: (generalmente trascurabile) tempo di permanenza nella coda di invio
- $t_"elaborazione"$: (generalmente trascurabile) tempo impegato dal nodo per decidere come inoltrare il pacchetto
- $t_"trasmissione"$: $"dimensione pacchetto"/"bitrate"$ tempo necessario per trasferire i dati dal dispositivo al mezzo fisico
- $t_"propagazione"$: $"distanza"/"velocità mezzo"$ tempo che impega l'informazione ad arrivare da un capo all'altro del mezzo fisico

=== Codifiche

I dati quando vengono trasmessi sono codificati. La classica codifica è $1$ alto, $0$ basso.

==== Codifica di Manchester

#informalmente[
  Viene trasferito anche il clock insieme ai dati, codifica autosincronizzante
]

==== Codifica Non Return to Zero Inverted (NRZI)

#informalmente[
  $0$ mantiene lo stesso segnale che lo precedeva, $1$ lo inverte.
  Si lavora sempre con cambi di fronte (come nella codifica Manchester)
]

=== Frammentazione

#informalmente[
  Non è possibile mandare file interi, vengono frammentati in tanti frame (livello 2), pacchetti (livello 3) o segmenti (livello 4)
]

== Logical Link Layer (LLC)

#informalmente[
  Gestione logica del livello, controllo di flusso ed errori
]

=== Livello 2 best-effort

#informalmente[
  Ci prova a trasmettere senza errori, ma possono accadere e non vengono controllati o corretti
]

==== Character stuffing

#informalmente[
  Differenziare caratteri di controllo da caratteri nel payload. Vengono aggiunti dei caratteri appositi (per disambiguare) quando nel payload si incontrano determinati caratteri riservati al controllo
]

- $"DELSTX" -> "Inizio frame"$
- $"DELETX" -> "Fine frame"$

Sostituisco tutti i $"DEL"$ singoli con:
- $"DEL" -> "DELDEL"$

#informalmente[
  Quando leggo un DEL non susseguito da un altro DEL allora so che quello è controllo
]

==== Bit stuffing

#informalmente[
  Stesso principio del character stuffing ma con i bit
]

Disambiguare $01111110$ da tanti $1$ nel payload:
- ogni cinque $1$ inserisco uno $0$

In lettura se leggo sei $1$ allora è la flag, altrimenti posso scartare lo $0$ dopo il quinto $1$.

=== Livello 2 affidabile: High-Level Data Link Control (HDLC) e (Point-to-Point) PPP

#informalmente[
  Protocolli affidabili: controllano e correggono la perdita di messaggi, attraverso dei messaggi di ACK
]

Per fare ciò usano dei meccanismi come:

==== Idle RQ

#informalmente[
  Fino a quando non ricevo un ACK per l'ultimo segmento mandato aspetto. Quando scade il timer di ritrasmissione ($R T O$) allora lo reinvio e aspetto ancora l'ACK
]

#nota[
  Identificatori distinti: $1$
]

==== Protocolli a finestra (Continuous RQ)

#informalmente[
  Mandano più frame prima di aspettare (non solo uno come Idle RQ)
]

#attenzione[
  Cambia l'utilizzo del canale, dipende anche la finestra $k$
]

===== Go back-N

#informalmente[
  Il mittende continua a mandare i $k$ frame successivi all'ultimo frame convalidato. Il destinatario scarta tutto ciò che è fuori sequenza
]

#nota[
  Identificatori distinti: $k+1$
]

===== Selective repeat

#informalmente[
  Il mittente manda $k$ frame. Il destinatario tiene in un buffer tutti i frame ricevuti (non duplicati), anche quelli fuori sequenza. Manda come ACK l'ultimo frame in sequenza, il mittente rimanderà solo il primo senza ACK, credendo che tutti gli altri siano stati ricevuti

  #attenzione[
    Se $k = 3$ e vengono persi i frame $2, 3$ allora il destinatario farà ACK di $1$, il mittente manderà solo $2$ e dopo l'ACK di $2$ allora manderà $3$. Questo perchè solo a finestra "completa" vengono mandati tutti, dopo ne manda solo quello "richiesto", essendo ottimista che gli altri siano ricevuti anche se fuori sequenza
  ]
]

#nota[
  Identificatori distinti: $2k$
]

====== ACK selettivo

#informalmente[
  Un ACK valida solo il frame specificamente validato
]

====== ACK cumulativo

#informalmente[
  Un ACK valida tutti i frame minori o uguali al frame validato
]

#attenzione[
  Spesso è conveniente usare un approccio misto: mittente Go back N, destinatario Selective repeat
]

== Reti broadcast

#informalmente[
  Reti che comunicano mandando ogni frame a tutte le stazioni, poi solo il destinatario la terrà, gli altri scartano
]

=== Local Area Network (LAN)

IEEE 802.3

=== Virtual Local Area Network (VLAN)

IEEE 802.1Q

=== Accesso al canale: collisioni

#informalmente[
  Se si usa un canale condiviso, possono avvenire delle collisioni: più stazioni trasmettono sullo stesso cavo e i dati si "schiacciano a vicenda", diventano illeggibili
]

==== Algoritmi deterministici

===== Round robin

#informalmente[
  Viene dato un tot di tempo ad ogni stazione, molto inefficiente (anche se non hai da comunicare usi il tuo tempo)
]

===== Token-ring

#informalmente[
  Solo chi ha il token può comunicare, se non hai nulla da dire fai girare il token velocemente. Prolemi:
  - se il token si perde?
  - se chi ha il token non lo cede più?
]

==== Algoritmi probabilistici

===== ALOHA

#informalmente[
  Appena si ha da trasmettere si trasmette, se avviene una collisione si aspetta tempo randomico $t$ (calcolato basandosi su una Poisson). Non ci si ferma appena avviene una collisione ma si trasmette comunque tutto
]

Algoritmo *probabilistico* per gestire reti broadcast, cercando di limitare le collisioni.

Viene designato un _centro_, a cui tutti i dispositivi trasmettono, chiamato _satellite_. Il satellite ritrasmette in _maniera passiva_ a tutte le stazioni collegate ad esso.

Le regole del protocollo sono molto _banali_:

- Se hai dati da mandare, *mandali* _(*senza* controllare che nessun altro stia trasmettendo)_
- Se stai mandando dati e ricevi dati da un'altra stazione, allora c'è stata una collisione. Tutte le stazioni dovranno ritrasmettere *più tardi*

La parte importante del protocollo è il _"più tardi"_ in caso di collisioni, ovvero la parte _probabilistica_ dell'algoritmo, basato su delle assunzioni:

- tutti i frame hanno la stessa lunghezza
- tutte le stazioni hanno un solo frame da mandare alla volta _(non sono presenti code)_
- le stazioni che provano a trasmettere seguono una #link("https://en.wikipedia.org/wiki/Poisson_distribution")[distribuzione di Poisson]

Viene calcolato un *tempo randomico* $T$ _(sfruttando queste assunzioni)_ e viene riprovata la trasmissione.

L'efficienza dell'algoritmo ALOHA è calcolata del *18.4%*, ovvero solo il 18% del tempo totale è utilizzato per trasmissioni con successo.

===== Carrier Sense Multiple Access with Collision Detection (CSMA-CD)

#informalmente[
  Si effettua CS: se il canale è vuoto si trasmette, altrimenti si aspetta.

  Quando avviene una collisione, allora si interrompe subito la trasmissione e si aspetta tempo randomico che aumenta esponenzialmente (BEB, spiegato sotto) (per 15 volte, dopo si abortisce la comunicazione)
]


Protocollo (ormai obsoleto) utilizzato su ethernet non #link("https://en.wikipedia.org/wiki/Duplex_(telecommunications)")[full-duplex]. Permette una migliore efficienza rispetto all'ALOHA.

Funzionamento del protocollo:

- se il cavo non è _IDLE_, allora aspetta
- se il cavo è _IDLE_, allora inizia a trasmettere
  - se avviene una collisione (quello che viene inviato è diverso da quello che si riceve), allora:
    - trasmetti un segnare di JAM fino a garantire la grandezza minima del frame (garantire che tutte le stazioni rilevano la collisione)
    - incrementa il _Retrasmission counter_
    - se il _Retrasmission counter_ ha raggiunto il numero massimo di tentativi, allora annulla la trasmissione
    - altrimenti, aspetta il tempo calcolato usando il _Random backoff period_ e riprova

Per garantire che tutte le stazioni rilevino la collisione, è necessario che il *tempo di trasmissione* sia maggiore di *due volte il tempo di propagazione* $t_x > 2 t_p$. Questo è garantito dallo standard *IEEE 802.3*, che impone dei vincoli sulla _lunghezza dei cavi_ (massimo 2500 metri) e la _grandezza dei frame_ (minimo 64 Byte).

#informalmente[
  Per rilevare una collisione vengono confrontati i dati in _uscita_ con quelli in _entrata_. Questo è possibile solo se i dati _"di ritorno"_ (natura broadcast della rete) sono abbastanza veloci a tornare *prima* che l'*invio del frame sia finito*. Questo è descritto da: $ t_x > 2 t_p $
  Di conseguenza, se il cavo è troppo lungo (o il frame è troppo piccolo), allora questo meccanismo non funziona, in quanto l'host non riscirà a capire se la frame che ha colliso fosse sua oppure no.
]

Una volta rilevata una _collisione_, allora gli host _aspettano_ generando un *tempo randomico di backoff*. Questo tempo è *esponenziale* rispetto al _numero di tentativi falliti_ (*retrasmission counter*).

- 1P: carrier sense persistente, appena si libera trasmetto
- 0P (termine non standard): carrier sense a intervalli randomici, se libero trasmetto, altrimenti aspetto tempo random

*Standard IEEE 802.3:*

- $10 M b p s$
  - Grandezza minima frame: $t_x >= 51.2 mu s$, $64 B$
  - Lunghezza cavo: $<= 2500 m$
- $1 G b p s$
  - Grandezza minima frame: $t_x >= 512 n s$, $512 B$
  - Lunghezza cavo: $<= 200 m$

====== Binary Exponential Backoff (BEB)

#informalmente[
  Ogni volta che avviene una collisione si aspetta tempo random che aumenta in manieta esponenziale con l'aumentare delle collisioni. Alla 16 collisione si abortisce la comunicazione
]

= Livello 3: Rete _(Livello 2 TCP/IP)_

Unità: pacchetto

#informalmente[
  Fanno comunicare delle sottoreti "distanti" che formano internet
]

== Addressing

#informalmente[
  Fornire un indirizzo univoco ad ogni host presente in internet, in modo che è possibile comunicarci

  #attenzione[
    Non è del tutto vero, molto molto molto spesso tanti host hanno un unico IP pubblico (quello della LAN) e tanti IP privati
  ]
]

=== Internet Protocol Version 4 (IPv4)

==== Header pacchetto

#figure(caption: "Header pacchetto IP")[#image("imgs/ip-header.png", width: 80%)]

===== Frammentazione

Quando viene frammentato un dato in tanti pacchetti IP gli header importanti sono:
- *Identification (ID)*: identificatore (uguale in tutti i pacchetti che formano il dato diviso)
- *More fragments (MF)*: se ci sono altri frammenti dopo il corrente
- *Fragment offset*: quando è spostato il frammento corrente rispetto al totale del dato (vengono contati 8 Byte alla volta)
- *Total size*: grandezza totale del dato da trasmettere
- *Payload size*: grandezza del payload di questo pacchetto

==== Subnet mask

#informalmente[
  Separa la parte che identifica la rete da quella che identifica gli host, maschera binaria di 32 bit
]

==== Suddivisione indirizzi pubblici

===== Classi NetID

#informalmente[
  Classi "statiche" con numero di host fissi
]

- Classe A: 8 bit di subnet mask
- Classe B: 16 bit di subnet mask
- Classe C: 24 bit di subnet mask
- Classi D ed E: riservate per scopi speciali

===== Classless Inter-Domain Routing (CIDR)

#informalmente[
  Il numero di bit di rete non è più per forza 8, 16 o 24 ma può essere qualsiasi numero. Si indica con \<IP>/\<numero di 1 nella subnet>, ad esempio 238.77.1.78/23
]

==== Suddivisione indirizzi privati: subnetting

#informalmente[
  È possibile suddividere la parte privata di una rete in tante altre sottoreti, effettuando del subnetting
]

==== Comunicazione

===== Network Address Translation (NAT)

#informalmente[
  Serve per limitare l'uso di IPv4, ogni rete ha un solo IP pubblico e tanti privati. Traduce le richieste effettuate dall'interno della rete da IP privato a IP pubblico.

  #attenzione[
    Per fare ciò ha bisogno anche di informazioni di livello 4, ovvero la porta
  ]
]

Formato tabella:
- IP sorgente
- Porta sorgente
- IP destinazione
- Porta destinazione
- Porta NAT

===== Address Resolution Protocol (ARP / RARP)

#informalmente[
  All'interno di una LAN è necessario parlare a livello 2, quindi utilizzano i MAC address (non IP). ARP serve per tradurre un indirizzo IP ad un indirizzo MAC, inviando una richiesta il broadcast
]

- Se in ARP cache: allora si ha già il MAC
- Altrimenti si manda in broadcast una richiesta con:
  - IP dell'host di cui ci serve il MAC
  - Nostro IP
  - Nostro MAC
- L'host che stiamo cercando risponde al nostro MAC con suo il MAC

#attenzione[
  La cache ARP ha un timeout, scadono le entry
]

#informalmente[
  RARP fa la stessa cosa ma al contrario, dato un MAC restituisce un IP (molto molto poco usato)
]

===== Dynamic Host Configuration Protocol (DHCP)

#informalmente[
  Quando un host di connette ad una rete non ha (ancora) un IP (privato), qualcuno glielo deve fornire, questo qualcuno è il server DHCP

  #attenzione[
    Ce ne possono essere più di uno in una rete
  ]
]

- Discover: il dispositivo manda in broadcast (src: 0.0.0.0, dst: 255.255.255.255) una richiesta con un certo transaction ID
- Offer: i server DHCP rispondono in broadcast (ma con stesso transaction ID) offrendo un IP
- Request: il dispositivo (sempre con src 0.0.0.0 e dst 255.255.255.255) ne accetta una
- ACK: il server risponde in broadcast con ACK, da questo momento il client ha un IP

===== Internet Control Message Protocol (ICMP)

#informalmente[
  Informazioni di controllo del flusso di internet, ad esempio segnalazione problemi, congestione o ping
]

=== Internet Protocol Version 6 (IPv6)

#informalmente[
  Nuova versione del protocollo, con molti (mooolti) più indirizzi disponibili di IPv4 (128 bit), questi non finiscono
]

==== Header pacchetto

#figure(caption: "IPv6 header")[#image("imgs/ipv6-header.png", width: 60%)]

#informalmente[
  Sono stati snelliti di molto gli header, ora sono come una lista concatenata, il next header punta ad un campo opzionale che può essere presente tra la fine degli header ed il payload. A sua volta ogni next header può puntare ad un successivo, fino all'ultimo che fa da "tappo"
]

===== Source routing (esatto ed approssimato)

#informalmente[
  Il source routing permette di far viaggiare il pacchetto seguendo un percorso prestabilito (e non deciso dai router)

  - esatto: vengono specificati tutti i router da cui passare (tramite header opzionali)
  - approssimato: vengono specificati solo alcuni punti chiave (tramite header opzionali)
]

Certo, ecco dei rapidi riassunti per ogni header:

===== Source routing (esatto ed approssimato)

#informalmente[
  Il source routing permette di specificare il percorso esatto che un pacchetto deve seguire attraverso la rete, piuttosto che lasciare che i router decidano il percorso.

  - *Esatto:* Viene definito ogni singolo router attraverso cui deve passare il pacchetto (tramite header opzionali).
  - *Approssimato:* Vengono definiti solo alcuni punti chiave del percorso (tramite header opzionali).
]

===== Frammentazione

#informalmente[
  A differenza di IPv4, la frammentazione può avvenire solo al nodo sorgente e NON lungo il percorso (cosa fatitbile il IPv4). Questo scarica overhead dai router lungo il cammino, ma non permette al pacchetto di passare da link il cui MTU (Maximum Trasmissiun Unit) è maggiore della grandezza del pacchetto

  #nota[
    Vengono mandati dei pacchetti MTU discoveri attraverso ICMP per sapere se un pacchetto può passare o meno
  ]
]

==== Compatibilità con IPv4

Soluzioni:
- *Tunneling*: incapsulare pacchetto IPv6 in un pacchetto IPv4, ad esempio per connettere reti IPv6 isolate
- *Dual stack*: dispositivi che hanno sia un'interfaccia IPv4 che IPv6 in modo da poter comunicare con entrambi i protocolli
- *NAT*: utilizzo di NAT che trasformano indirizzi IPv4 in IPv6 o viceversa per far comunicare reti che utilizzano protocolli diversi

== Routing

#informalmente[
  Instradare i pacchetti per raggiungere la loro destinazione, facendo possibilmente il percorso migliore (numero di HOP o tempo)
]

=== Distance Vector (DV)

#informalmente[
  - Gli host mantengono una tabella con:
    - Nodo da raggiungere
    - Distanza
    - Primo HOP per raggiungerlo
  - Ogni tot tempo viene propagato questo Distance vector (SOLO nodo + distanza, senza link utilizzato) ai propri adiacenti
  - Gli adiacenti aggiornano le distanze
]

==== Trigger update

#informalmente[
  Al posto di aspettare che scada il timer e poi propagare, viene propagato appena c'è un cambiamento

  #attenzione[
    Non risolve il count to infinity o l'effetto bouncing in quanto il pacchetto si può perdere
  ]
]

==== Problematiche

===== Count to infinity ed Effetto bouncing

#informalmente[
  Dato che non viene propagato quale link si usa per raggiungere un nodo, allora se ad esempio di rompe un link e si perde il pacchetto che aggiorna in negativo, allora si forma un circolo vizioso dove l'adiacente comunica al nodo su cui si è rotto il link che in realtà è raggiungbile, senza accorgersi che passa attraverso di lui (quindi si inizia a rimbalzare e si arriva a distanza infinita)
]

===== Split Horizon

#informalmente[
  Si condivide sul link che si vuole utilizzare distanza infinita, in modo da non poter causare problemi
]

==== Routing Information Protocol (RIP)

#informalmente[
  Usa i distance vector
]

=== Link State (LS)

#informalmente[
  Ogni nodo condivide con tutto il resto della rete (in flooding) le informazioni sui suoi adiacenti, in modo che ogni nodo della rete potrà avere un idea chiara di tutta la rete (ognuno costruisce il grado completo) ed ognuno può calcolare il percorso migliore.

  Vengono aggiunti anche gli ACK e i sequence number, per evitare che le informazioni di un nodo arrivino ad un altro attraverso percorsi diversi e continuino a viaggiare all'infinito
]

==== Open Shortest Path First (OSPF)

#informalmente[
  Usa i Link state
]

==== Spanning tree broadcast

=== Path Vector

#informalmente[
  Simile ai distance vector, ma è presente tutta la path che deve percorrere, per evitare di causare problemi come il count to infinity. Ogni nodo condivide con i suoi adiacenti tutto il percorso per raggiungere altri nodi
]

==== Border Gateway Protocol (BGP)

#informalmente[
  Usa i Path vector
]

=== Multi Packet Label Switching (MPLS)

#informalmente[
  Per aumentare l'efficienza, spesso nelle aree0 e grandi reti, al posto che fare routing IP si effettua routing basato su etichette.

  I router agli estremi dell'area incapsulano il pacchetto in dei pacchetti apposta dotati di un'etichetta. I router interni alla rete in base all'etichetta e alla porta in ingresso, smistano il pacchetto cambiando etichetta e porta in uscita

  #nota[
    I router agiscono come dei grandi switch, senza aprire il pacchetto IP e calcoalre il percorso. Molto efficiente
  ]
]

=== Architettura ottimizzata

==== Autonomous system (AS)

#informalmente[
  Grandi reti gestite da una singola organizzazione (spesso internet service provider ISP), ed utilizzano una certa politica di routing.

  Tanti AS sono connessi tra loro attraverso la internet backbone formano  tutta internet. Vengono etichettati da IANA (Internet Assigned Numbers Authority)
]

==== Designated router e Software Defined Network (SDN)

#informalmente[
  Spesso, in grandi reti, sono presenti dei router designati a calcolare i percorsi migliori e comunicarli, centralizzando le operazioni di calcolo.

  Quando questa funzione è spostata in cloud (per evitare singolo punto di failure e garantire maggiore affidabilità) si parla di Software defined network
]

== Schedulazione e priorità: Quality of Service (QoS)

#informalmente[
  In base ai servizi utilizzati, alcuni pacchetti possono avere una priorità maggiore rispetto ad altri (come streaming rispetto ad email).

  Per assecondare queste richieste, esiste la Quality of Service, che staibilisce appunto una priorità ai vari pacchetti, che viene comunicata ai router (che attuano delle politiche per adattarsi)
]

=== Weighted Fair Queuing (WFQ)

#informalmente[
  Un router possiede più code, ognuna con un certo peso. I pacchetti in ingresso vengono distribuiti sulle varie code in base alla loro priorità e viene assegnata ad ogni pacchetto una quantità di banda proporzionale in base alla priorità di quella coda
]

=== Call Admission

#informalmente[
  Quando tanti pacchetti al alta priorità devono viaggiare (come in una chiamata VoIP), allora viene effettuata una Call Admission: viene controllato se sono presenti abbastanza risorse per gestire questa call.

  Se queste risorse sono presenti la call viene avviata, altrimenti viene rifiutata
]

=== Token Bucket

#informalmente[
  Limita il numero di pacchetti che possono viaggiare:
  - vengono generati ad intervallo costante dei token
  - quando arriva un pacchetto controlla se sono presenti sufficienti token per passare
    - in caso positivo li preleva e passa
    - altrimenti viene scartato o viene messo in coda fino a quando non sono presenti abbastanza token
]

=== Tail drop e Random Early Detection (RED)

#informalmente[
  Tail drop:
  - quando c'è spazio nella coda di un router allora viene ammesso tutto
  - quando la coda è piena viene droppato tutto

  Random early detection:
  - quando si è sotto una certa soglia minima: viene accettato tutto
  - quando si è sopra una certa soglia massima: viene droppato tutto
  - quando si è tra le due soglie: alcuni pacchetti random vengono droppati (proporzionalmente a quanto è piena la coda)
]

= Livello 4: Trasporto _(Livello 3 TCP/IP)_

Unità: fragment

== Transmission Control Protocol (TCP)

#informalmente[
  Protocollo affidabile, stabilisce una connessione logica
]

=== Header e Pseudoheader TCP

#figure(caption: "Header TCP")[#image("imgs/tcp-header.png", width: 70%)]

#informalmente[
  Il pacchetto viaggia da un IP:porta ad un altro IP:porta, ma gli IP sono già nel pacchetto IP, inutile duplicarli nell'header TCP.

  Però il checksum viene effettuato anche andando ad estrarre i dati dal pacchetto IP, prendendo il nome di pseudoheader
]

=== Fasi della connessione

- Apertura
- Comunicazione
- Chiusura

==== Apertura: three way handshake

#figure(caption: "Header TCP")[#image("imgs/tcp-apertura.png", width: 60%)]

==== Comunicazione

#informalmente[
  Scambio di dati tra i due host
]

===== Controllo del flusso

====== Window Size $W_s$

#attenzione[
  Viene chiamata anche _Advertised window_
]

#informalmente[
  La finestra di ricezione viene negoziata tra il client ed il server quando viene stabilita la connessione.

  #nota[
    In realtà è scelta dal server e comunicata
  ]

  È quanto spazio il server ha disponibile per ricevere dati. Inizialmente sarà grande come la grandezza del buffer, mano a mano che riceve dati si riduce, comunicandolo al client.

  #attenzione[
    In realtà entrano in gioco altri controlli e va gestista anche la *congestione*
  ]

  #nota[
    Quando è grande più di 1MSS, allora significa che il client può mandare più segmenti senza aspettare il relativo ACK prima di mandarne di nuovi (protocollo a finestra)
  ]
]

====== Persistent timer

#informalmente[
  Salvaguarda il client.

  In caso che il client riceva una $W_s = 0$, allora deve aspettare fino ad una nuova notifica di finestra più grande per poter mandare dati. Ma se questo pacchetto si perde?

  Allora il client fa partire un timer, quando scade manda un _*Window probe*_ al server, richiedendo esplicitamente al server l'ACK

  #nota[
    In caso il server non risponda ai window probe viene chiusa la connessione
  ]
]

====== Keep alive timer

#informalmente[
  Salvaguarda il server.

  In caso il server non riceva nulla per un timer di tempo, allora manda un _*Keep alive probe*_ per controllare che il client non si sia disconnesso senza comunicarlo (ad esempio spento il PC). Se non risponde dopo un numero di probe, allora chiude la connessione
]

====== Silly Window Syndrome

#informalmente[
  Quando un estremo della connessione TCP è molto lento a produrre/consumare i dati da inviare/ricevuti, allora si avrà un graduale restringimento della finestra e l'invio di segmenti sempre più piccoli, causando un utilizzo inefficiente del canale.

  #attenzione[
    Può avvenire in entrambi i sensi, sia con client veloce e server lento che viceversa. In base al caso si utilizzano due soluzioni diverse _(descritte sotto)_
  ]
]

======= Algoritmo di Clark

Caso in cui il consumatore (server) è molto lento a leggere i dati dal buffer.

#informalmente[
  Il server è molto lento, quindi il buffer si svuota molto lentamente (ad esempio 1B alla volta). Per evitare di mandare tantissimi ACK con Window size minuscole (cresce di solo 1B), allora viene adottata la soluzione di Clark:

  si aspetta a mandare una nuova Window size fino a quando non è almeno:
  $ min(1/2 "bufferSize", "MSS") $

  #nota[
    MSS = Maximum Segment Size, la grandezza massima di un singolo segmento che può transitare sulla rete
  ]
]

======= Algoritmo di Nagle (Delayed ACK)

Caso in cui il produttore (client) è molto lento a produrre dati.

#informalmente[
  Il client è molto lento a produrre dati, ad esempio produce un byte alla volta (ad esempio una connessione netcat, ogni carattere premuto).

  Il problema è quindi mandare tanti piccoli messaggi con tanto overhead (20B IP + 20B TCP) per pochissimo payload (1B). La soluzione è usare l'algoritmo di Nagle e il *Timer di piggybacking*.

  Il server quando gli arriva un solo segmento più piccolo rispetto al MSS e alla Window size, allora aspetta o la ricezione di altri messaggi o un timer (di piggybacking) prima di mandare l'ACK.

  In questo tempo di "attesa" i messagi sul client si accumuleranno, mandando un unico frammento più grande
]

===== Gestione degli errori

#informalmente[
  Quando vengono persi degli ACK o dei fragment
]

====== Retrasmission Timeout (RTO)

#informalmente[
  Come a livello 2 affidabile, quando viene mandato un messaggio si fa partire un timer (RTO), se non arriva un ACK prima della fine del timer, allora viene rimandato lo stesso messaggio
]

======= Calcolo RTO

#nota[
  - RTT = Sampled rount trip time
  - Var = Varianza RTT
  - SRTT = Smoothed RTT
]

Tempo 0:
- RTO = 3 sec (da RFC è stato modificato a 1 sec)

Tempo 1:
- $S R T T = R T T$
- $R T T"Var" = (R T T) / 2$
- $R T O = S R T T + 4 dot R T T"Var"$

Tempo 2 o più:
- $S R T T = (1 - alpha) S R T T_"old" + alpha R T T$
- $R T T"Var" = (1 - beta) R T T"Var"_"old" + beta |R T T - S R T T_"old"|$
- $R T O = S R T T + 4 dot R T T"Var"$

======= Retransmission ambiguity: politica di Karn

#informalmente[
  Se viene perso un messaggio e scatta l'RTO, allora viene rimandato lo stesso messaggio. Il tempo di ritorno dell'ACK (RTT) deve venir usato per calcolare il prossimo RTO.

  Ma come faccio a sapere se l'ACK che ho ricevuto è solo stato molto lento ma del primo segmento che ho mandato o se si era perso e quindi l'ACK è del secondo segmento?

  Non viene scelto nessuno dei due, viene usata la *politica di Karn*, semplicemente il nuovo RTO è dimezzato:
  $ R T O = (R T O_"old") / 2 $
]

====== Fast retrasmission

#informalmente[
  Abbiamo detto che un segmento è rimandato quando scatta il suo RTO. Ma se stiamo mandando tanti segmenti alla volta e riceviamo tanti ACK cumulativi duplicati vuol dire che tanti segmenti fuori sequenza sono stati ricevuti.

  Quindi il problema non è la lentezza della rete, ma è molto probabile se si sia perso (dato che gli altri sono stati ricevuti), quindi è inutile aspettare il timer di RTO ma possiamo rimandare subito il segmento. Questo meccanismo scatta con 3 ACK cumulativi duplicati

  #nota[
    Fast retrasmit perchè appunto non aspetta lo scadere dell'RTO ma rimanda prima
  ]
]

====== Timestamp

#informalmente[
  All'interno dell'header TCP vengono inseriti dei timestamp, in modo che non si possano creare ambiguità (Retrasmission ambiguity) e sia più facile calcolare RTT (sottrazione tra timestamp invio e tempo alla ricezione)
]

===== Controllo della congestione: finestra di congestione $W_c$

#informalmente[
  Non basta gestire la finestra che il server può ricevere (window size), bisogna anche tenere conto della congestione della rete.

  Per fare ciò si utilizza la finestra di congestione, che è sempre limitata superiormente dalla window size.

  Si inizia con una finestra di congestione piccola e la sin ingrandisce fino a quando non ci sono dei problemi (o si raggiunge la Window size)
]

====== Slow start

#informalmente[
  Si inizia mandano poco alla volta: di solito 1MSS.

  Per ogni ACK ricevuto allora si ingrandisce la finestra di 1, effettivamente *duplicando* la grandezza della finstra ogni volta.

  $ C_w = 2 dot C_w $

  Questo avviene fino al ragguingimento della *Slow Start Treshold (SST)*
]

====== Congestion avoidance

#informalmente[
  Si inizia a rallentare: per ogni finestra completa tutta validata (non per ogni segmento, per ogni finestra completa) si *aumenta di 1* la grandezza della finestra, effettivamente facendo crescere linearmente la finestra

  $ C_w = 1 + C_w $
]

====== Fase costante

#informalmente[
  Quando si raggiunge la Window size allora non si può più aumentare (ovviamente), quindi si continua in modo costante (se non ci sono errori ovviamente)

  $ C_w = C_w $
]

#figure(caption: "Slow start treshold")[#image("imgs/congestion-window.png", width: 80%)]

====== Errori

In caso avvengano degli errori:

- Fast retrasmit:
  - $S S T = C_w / 2$
  - $C_w = S S T_"new"$

  #figure(caption: "Errore: fast retrasmit")[#image("imgs/congestion-window-fast-retrasmit.png", width: 80%)]

- Scadenza del timer RTO:
  - $S S T = C_w / 2$
  - $C_w = 1 M S S$

  #figure(caption: "Errore: scandeza RTO")[#image("imgs/congestion-window-rto.png", width: 80%)]

==== Chiusura

#informalmente[
  La chiusura è asimmetrica, ovvero uno dei due host comunica la chiusura quando l'altro può ancora star comunicando/ha ancora da comunicare
]

===== Four way close

Viene usata la primitiva `close()`

#informalmente[
  Chiusura da standard completa senza problemi, entrambi accettano la fine e nessuno dei due ha da trasmettere
]

#figure(caption: "TCP 4 way close")[#image("imgs/tcp-four-way-close.png", width: 40%)]

===== Three way close

Viene usata la primitiva `close()`

#informalmente[
  Il client chiede la chiusura ma il server ha ancora degli ACK da mandargli, quindi viene accorpato in un unico messaggio gli N ack mancanti, l'ACK del FIN e il FIN (quindi le due freccie centrali del grafico sono unite)

  #attenzione[
    Client e server sono interscambiabili, uno ha ancora ACK da mandare mentre l'altro chiude la connessione
  ]
]

===== Half close

Viene usata la primitiva `shutdown()`

#informalmente[
  Il client chiede di chiudere la connessione ma il server vuole ancora inviare dati
]

#figure(caption: "TCP Half close")[#image("imgs/tcp-half-close.png", width: 80%)]

== User Datagram protocol (UDP)

= Livello 7: Applicazione _(Livello 4 TCP/IP)_

== Domain Name System (DNS)

=== Risoluzione iterativa

=== Risoluzione ricorsiva

== File Transfer Protocol (FTP)

== Hyper Text Transfer Protocol (HTTP)

Versione in-band (sia controllo che dati su un'unica connessione TCP) del FTP

https://www.digitalocean.com/community/tutorials/http-1-1-vs-http-2-what-s-the-difference

=== HTTP/1.0

=== HTTP/1.1

==== Pipelining e Head-of-Line Blocking

==== Resource Inlining

=== HTTP/2

==== Streams

==== Server push

==== Compressione

=== HTTP/3

==== QUIC (over UDP)

=== HTTPS

== Email

=== User Agent (UA)

=== Message Transfer Agent (MTA)

=== Invio: Simple Mail Transport Protocol (SMTP)

=== Ricezione

==== Internet Message Access Protocol (IMAP)

==== Post Office Protocol (POP 3)

=== Codifica Base64

== Content Delivery Network (CDN)

== Dynamic Adaptive Streaming over HTTP (DASH)

== Session Initiation Protocol (SIP) e Voice over IP (VoIP)

// numerazione appendici
#set heading(numbering: "A.1.")
#counter(heading).update(0)

= Lista acronimi

/ AS: Autonomous System
/ BEB: Binary Exponential Backoff
/ BGP: Border Gateway Protocol
/ CIDR: Classless Inter-Domain Routing
/ CSMA-CD: Carrier Sense Multiple Access with Collision Detection
/ DASH: Dynamic Adaptive Streaming over HTTP
/ DHCP: Dynamic Host Configuration Protocol
/ DNS: Domain Name System
/ DV : Distance Vector
/ FQDN: Fully Qualified Domain Name
/ FTP: File Transfer Protocol
/ HDLC: High-Level Data Link Control
/ HTTP: Hyper Text Transfer Protocol
/ HTTPS: Hyper Text Transfer Protocol Secure
/ IANA: Internet Assigned Numbers Authority
/ ICMP: Internet Control Message Protocol
/ IMAP: Internet Message Access Protocol
/ IP: Internet Protocol
/ IPv4: Internet Protocol Version 4
/ IPv6: Internet Protocol Version 6
/ ISP: Internet Service Provider
/ LAN: Local Area Network
/ LLC: Logical Link Control
/ LS: Link State
/ MAC: Multiple Access Control and Media Access Control
/ MAN: Metropolitan Area Network
/ MPLS: Multi Packet Label Switching
/ MSS: Maximum Segment Size
/ MTA: Message Transfer Agent
/ MTU: Maximum Transmission Unit
/ NAT: Network Address Translation
/ NRZI: Non Return to Zero Inverted
/ OSPF: Open Shortest Path First
/ PISO: Parallel In Serial Out
/ POP3: Post Office Protocol
/ PPP: Point-to-Point Protocol
/ QoS: Quality of Service
/ RED: Random Early Detection
/ RIP: Routing Information Protocol
/ RARP: Reverse Address Resolution Protocol
/ RTD: Round Trip Delay
/ RTO: Retrasmission Timeout
/ RTT: Round Trip Time
/ SDN: Software Defined Network
/ SIPO: Serial In Parallel Out
/ SIP: Session Initiation Protocol
/ SMTP: Simple Mail Transfer Protocol
/ SNMP: Simple Network Management Protocol
/ SST: Slow Start Threshold
/ TCP: Transmission Control Protocol
/ UA: User Agent
/ UDP: User Datagram Protocol
/ VLAN: Virtual Local Area Network
/ VoIP: Voice over IP
/ WAN: Wide Area Network
/ WFQ: Weighted Fair Queuing

= Esercizi

- Massimizzare grandezza finestra:
  - calculare $U$ (senza $k$)
  - trovare $k$ che lo fa avvicinare a $1$
  - _parte non sicura, non è detto che serva_: questo $k$ è rappresentabile con dei bit (quindi a potenza di 2)?:
    - in base a se è gobackn ($N+1$) o selective repeat ($2N$), allora capire quanti indentificati diversi servono
    - se il numero di identificatori è multiplo di 2 allora ok, altrimenti spiegare perchè si sprecherebbero dei bit

- Calcolare grandezza minima frame:
  - imporre $t_x > 2t_p$
  - sostituire $t_x$ con $N / "banda"$
  - isolare $N$ e risolvere
  - in caso ci siano ripetitori che danno aggiungono ritardo, sommarli a $t_p$


- Esercizi in generali sui tempi di propagazione:
  - sostituire tutti i dati che abbiamo e isolare l'incognita

- Frammentare un pacchetto IP in modo che possa passare da una LAN ethernet
  - massima dimensione per rete ethernet: 1500B (1480 payload + 20 header IP)
  - header importanti:
    - identification: uguale in tutti i nuovi pacchetti
    - more fragments: tutti a 1 tranne l'ultimo
    - fragment offset: somma dei pacchetti precedenti / 8 (è un offset a gruppi di 8 Byte
    - payload size: grandezza totale prima di essere frammentato
    - fragment size: grandezza del payload di questo pacchetto
