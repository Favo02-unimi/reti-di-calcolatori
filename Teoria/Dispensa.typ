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

// indice
#outline(
  title: "Indice",
  indent: auto
)

#pagebreak()

= Introduzione

== Cos'è una rete

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

- Ordine originale
- No duplicati
- Pacchetti corretti

== Composizione di una rete

=== Dispositivi di rete

Porte PISO (Parallel In Serial Our) / SIPO (Serial In Parallel Out)

==== Hub (livello 1)

==== Bridge (livello 2)

==== Switch (livello 2)

==== Router (livello 3)

=== Mezzi trasmissivi (cavi)

- Rame/Coassiale/Telefono: $2 dot 10^8 space b p s$
- Fibra: $3 dot 10^8 space b p s$

== Regole di una rete: protocolli

=== Modello ISO/OSI

=== Stack TCP/IP

= Livello 2: Data Link

Unità: frame

== Multiple Access Control (MAC)

Accesso fisico al canale

=== Tempi di trasmissione

==== Velocità di trasmissione $V_x$

==== Tempo di trasmissione $t_x$

==== Larghezza di banda e Clock

==== Tempo di propagazione $t_p$

==== Rount trip time $R T T$

==== Retrasmission timeout $R T O$

==== Efficienza della rete $U$

==== Jitter

==== Latenza

=== Codifiche

==== Codifica di Manchester

==== Codifica Non Return to Zero Inverted (NRZI)

=== Frammentazione

== Logical Link Layer (LLC)

Gestione logica del livello

=== Livello 2 best-effort

==== Character stuffing

==== Bit stuffing

=== Livello 2 affidabile: High-Level Data Link Control (HDLC) e (Point-to-Point) PPP

==== Utilizzo del canale

==== Idle RQ

==== Protocolli a finestra (Continuous RQ)

===== Go back-N

Almeno $N+1$ identificatori

===== Selective repeat

Almeno $2  N$ identificatori

== Reti broadcast

=== Local Area Network (LAN)

IEEE 802.3

=== Virtual Local Area Network (VLAN)

IEEE 802.1Q

=== Accesso al canale: collisioni

==== Algoritmi deterministici

===== Round robin

===== Token-ring

==== Algoritmi probabilistici

===== ALOHA

===== Carrier Sense Multiple Access with Collision Detection (CSMA-CD)

- 1P: carrier sense persistente
- 0P (termine non standard): carrier sense a intervalli randomici

*Standard IEEE 802.3:*

- $10 M b p s$
  - Grandezza minima frame: $t_x >= 51.2 mu s$, $64 B$
  - Lunghezza cavo: $<= 2500 m$
- $1 G b p s$
  - Grandezza minima frame: $t_x >= 512 n s$, $512 B$
  - Lunghezza cavo: $<= 200 m$

====== Binary Exponential Backoff (BEB)

= Livello 3: Rete

Unità: pacchetto

== Addressing

=== Internet Protocol Version 4 (IPv4)

==== Header pacchetto

===== Frammentazione

==== Sottoreti

===== Classi NetID

===== Subnetting

===== Classless Inter-Domain Routing (CIDR)

==== Comunicazione

===== Network Address Translation (NAT)

===== Address Resolution Protocol (ARP / RARP)

===== Dynamic Host Configuration Protocol (DHCP)

- Discover
- Offer
- Request
- ACK

===== Internet Control Message Protocol (ICMP)

=== Internet Protocol Version 6 (IPv6)

==== Header pacchetto

===== Frammentazione

==== Compatibilità con IPv4

== Routing

=== Distance Vector (DV)

==== Problematiche

===== Count to infinity ed Effetto bouncing

===== Split Horizon

==== Routing Information Protocol (RIP)

=== Link State (LS)

==== Open Shortest Path First (OSPF)

==== Spanning tree broadcast

=== Path Vector

==== Border Gateway Protocol (BGP)

=== Multi Packet Label Switching (MPLS)

=== Architettura ottimizzata

==== Autonomous system (AS)

==== Designated router e Software Defined Network (SDN)

== Schedulazione e priorità

=== Quality of Service (QoS)

=== Weighted Fair Queuing (WFQ)

=== Call Admission

=== Token Bucket

=== Random Early Detection (RED)

#pagebreak()
// numerazione appendici
#set heading(numbering: "A.1.")
#counter(heading).update(0)

= Lista acronimi


= Esercizi

#pagebreak()
#pagebreak()

#line(length: 100%)
= #text(size: 20pt)[APPUNTI "VECCHI" DA SMISTARE:]

= Concetti preliminari/Varie

== Protocollo

Un protocollo è un algoritmo distribuito, che organizza la comunicazione tra entità:

- realizza le *macchine a stati finiti* che governano le entità
- impone una *serie di convenzioni* sui messaggi scambiati

== Unità di misura

Utilizzeremo soprattutto $s$ (secondi), $b$ (bit) e $B$ (byte), con relativi multipli:

- $T$ tera: $10^12$
- $G$ giga: $10^9$
- $M$ mega: $10^6$
- $K$ kilo: $10^3$
- $m$ milli: $10^(-3)$
- $mu$ micro: $10^(-6)$
- $n$ nano: $10^(-9)$

= Roba da spostare al suo posto
// TODO: spostare questa roba all'interno del suo livello/capitolo
== Commutazione

È la scelta di un percorso (inteso come linea di ingresso-uscita) al fine di inviare un messaggio.

/ Commutazione di messaggio:

Il messaggio viene inviato per intero sulla rete.

Svantaggi:
- Il messaggio può raggiungere grandi dimensioni
- Difficile gestione nei nodi (ordine di instradamento, precendenze tra i messaggi)
- Difficoltà nell'allocare memoria data la variabilità della dimensione
- Se corrotto va reinviato interamente

/ Commutazione di messaggio:

Il messaggio viene inviato tramite pacchetti di dimensione standard.

Svantaggi:
- È necessaria una decomposizione e poi ricomposizione del messaggio
- Intestazioni ripetute su ogni pacchetto
- Tempo di arrivo e ordine non predicibile

== Router

Ogni nodo della rete è un *router*, collegati tra loro attraverso dei *link*. Ogni router ha al suo interno almeno un'*interfaccia di rete*, a sua volta composta da *due code* (buffer): una d'ingresso e una d'uscita.

Il router funziona grazie a tre processi:
- *scheduler*: si occupa di gestire quando e quali messaggi esaminare
- *interprete*: esamina i messaggi e li passa al processo di routing
- *routing*: determina in quale coda d'uscita mandare il pacchetto, attraverso la consultazione delle *tabelle di routing* (instradamento)

== Canale di trasmissione

Il cavo di trasmissione collega due dispositivi di rete, utilizzando delle porte *PISO* (Parallel In, Sequential Out)

== Tempi di invio e ricezione dei paccehtti

/ Tempo di latenza $T$:

Tempo totale impegato dal pacchetto per essere spedito e ricevuto.

$ T = t_"coda" + t_"elaborazione" + t_"trasmissione" + t_"propagazione" $

- $t_"coda"$: (generalmente trascurabile) tempo di permanenza nella coda di invio
- $t_"elaborazione"$: (generalmente trascurabile) tempo impegato dal nodo per decidere come inoltrare il pacchetto
- $t_"trasmissione"$: $"dimensione pacchetto"/"bitrate"$ tempo necessario per trasferire i dati dal dispositivo al mezzo fisico
- $t_"propagazione"$: $"distanza"/"velocità mezzo"$ tempo che impega l'informazione ad arrivare da un capo all'altro del mezzo fisico

=== Larghezza di banda e Clock

Grandezza relativa al materiale del canale che determina il limite superiore del tasso con cui si possono trasmettere bit su di esso.

#informalmente[
  Vedendo il cavo come un tubo e la corrente come acqua, la larghezza di banda è il quanto velocemente il tubo "aspira" via quello che gli viene immesso. Se viene immessa una piccola quantità di acqua ma troppo velocemente e il tubo non "aspira" abbastanza velocemente, allora si creano dei problemi
]

#attenzione[
  La larghezza di banda limita la velocità di clock di trasmissione
]

=== Velocità di trasmissione $V_X$

Espressa in $b p s$ (bit per second).

#nota[
  Un *clock* associato ad una *porta* di input/output determina la velocità di trasmissione sul canale
]

#informalmente[
  Massima velocità alla quale si possono "inserire" informazioni nel cavo
]

=== Tempo di trasmissione $T_X$

Espresso in $s$ (secondi), numero di bit da inviare diviso per la velocità di trasmissione

$ T_X = N / V_X $

#informalmente[
  Tempo necessario per "inserire" nel cavo tutti i dati che vogliamo mandare
]

== Affidabilità

Per garantire affidabilità di una trasmissione è necessario soddisfare tre proprietà:

- ogni pacchetto deve essere *corretto*
- garantire l'*ordine originale* dei pacchetti
- *assenza* di pacchetti *duplicati*

È possibile utilizzare due approcci garantire affidabilità:

- ogni *coppia di nodi* rende affidabile il link che li collega
- i *nodi agli estremi* rendeono affidabile l'intera trasmissione

=== Acknowledgment (ACK)

Messaggio inviato dal ricevente di un pacchetto verso il mittente per informarlo dell'arrivo del messaggio.

=== Round Trip Time $R T T$

Tempo impegato per inviare un pacchetto e ricevere una risposta (informalmente PING).

$ "RTT" = t_x + 2 t_p $

#informalmente[
  RTT = tempo di trasmissione del primo messaggio + tempo di propagazione + tempo di trasmissione dell'ack (trascurabile) + tempo di propagazione dell'ack (uguale al primo perché utilizza lo stesso percorso)
]

=== Round Trip Delay $R T D$

Tempo di propagazione per andata e ritorno

$ "RTD" = 2 t_p $

=== Timer di ritrasmissione $R T O$

Il tempo di ritrasmissione (Retransmission Time-Out) è il tempo massimo che il mittente aspetta un ack dal destinatario dopo il quale verrà reinviato il pacchetto. L'RTO è sufficiente che sia leggermente più grande del RTT.

$ T_R = "RTT" + epsilon, epsilon > 0 $

Con $epsilon$ solitamente 1 o 2 ms

=== Varianza o Jitter

Il _Jitter_ è la varianza tra i tempi di latenza dei vari pacchetti.

Tra due pacchetti arrivati a $t_1$ e $t_2$ con $t_1 = t_2 + a$ la varianza è $a$.

Per compensare problemi di latenza e di pacchetti persi nelle applicazioni real time si utilizza un buffer di riproduzione.

=== Latenza //??

= Livello 2 - Data Link

== Framing

Normalmente andrebbe aggiunga un'intestazione _STX_ (Start of text) in testa e una _ETX_ (End of Text) in coda.

Ma siccome _STX_ ed _ETX_ possono trovarsi all'interno dei dati possiamo utilizzare due tecniche per rendere uniche le intestazioni:

/ Character Stuffing:
- A _STX_ e _ETX_ sostituisco _DELSTX_ e _DELETX_
- In fase di tramissione duplico ogni _DEL_ all'interno del frame
- In ricezione elimino tutti i _DEL_ duplicati
- Se quando si legge un _DEL_ subito dopo si trova un _ETX_ allora sono in coda //TODO: da rivedere

/ Bit Stuffing:

In testa e in coda vengono utilizzate delle sequenze di n bit a 1 (ad esempio 6).

In fase di tramissione per ogni sequenza di 5 bit a 1 viene inserito un bit a 0 che verrà scartato in fase di ricezione.

== Data Link affidabile

Di seguito vengono presentati alcuni protocolli per la tramissione affidabile a livello 2 (anche se non più usati).

Questi protocolli utilizzato il metodo _ARQ_ (Automatic Repeat Request).


=== ALOHA

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

=== CSMA-CD 1P

Protocollo (ormai obsoleto) utilizzato su ethernet non #link("https://en.wikipedia.org/wiki/Duplex_(telecommunications)")[full-duplex]. Permette una migliore efficienza rispetto all'ALOHA.

Funzionamento del protocollo:

- se il cavo non è _IDLE_, allora aspetta
- se il cavo è _IDLE_, allora inizia a trasmettere
  - se avviene una collisione (quello che viene inviato è diverso da quello che si riceve), allora:
    - trasmetti un segnare di JAM fino a garantire la grandezza minima del frame (garantire che tutte le stazioni rilevano la collisione)
    - incrementa il _Retrasmission counter_
    - se il _Retrasmission counter_ ha raggiunto il numero massimo di tentativi, allora annulla la trasmissione
    - altrimenti, aspetta il tempo calcolato usando il _Random backoff period_ e riprova

Per garantire che tutte le stazioni rilevino la collisione, è necessario che il *tempo di trasmissione* sia maggiore di *due volte il tempo di propagazione* $T_X > 2 T_P$. Questo è garantito dallo standard *IEEE 802.3*, che impone dei vincoli sulla _lunghezza dei cavi_ (massimo 2500 metri) e la _grandezza dei frame_ (minimo 64 Byte).

#informalmente[
  Per rilevare una collisione vengono confrontati i dati in _uscita_ con quelli in _entrata_. Questo è possibile solo se i dati _"di ritorno"_ (natura broadcast della rete) sono abbastanza veloci a tornare *prima* che l'*invio del frame sia finito*. Questo è descritto da: $ T_X > 2 T_P $
  Di conseguenza, se il cavo è troppo lungo (o il frame è troppo piccolo), allora questo meccanismo non funziona, in quanto l'host non riscirà a capire se la frame che ha colliso fosse sua oppure no.
]

Una volta rilevata una _collisione_, allora gli host _aspettano_ generando un *tempo randomico di backoff*. Questo tempo è *esponenziale* rispetto al _numero di tentativi falliti_ (*retrasmission counter*).

== Codifica di Manchester

Lo scopo della codifica di Manchester è quello di trasferire, oltre alla sequenza di bit, anche il *clock del trasmettitore*, in modo da *sincronizzarlo* con il ricevente.

#informalmente[
  Convenzionalmente, per trasmettere 0 si mandano sul cavo 0V, mentre per trasmettere 1, 5V. Per garantire maggiore robustezza è preferibile utilizzare codifiche che permettono di distinguere la lunghezza di una sequenza tutta uguale
]

Per fare ciò applica dei frequenti cambi di tenzione, anche per trasmettere sequenze di bit uguali:
- $1$ viene codificato come un *fronte crescente*, prima _low_ poi _high_
- $0$ viene codificato come un *fronte decrescente*, prima _high_ poi _low_

#attenzione[
  La "larghezza" di _low_ e _high_ è mezzo clock
]

#figure(caption: [Codifica di Manchester])[
  #image("imgs/codifica-di-machester.png", width: 70%)
]

È necessaria però una fase di *sincronizzazione iniziale*, questa viene fatta attraverso il *preambolo*, ovvero 7 Byte, tutti nel formato `10101010` ed un ottavo `10101011`, chiamato flag di start.

#informalmente[
  La forma del preambolo è dovuto al fatto che alternare uni e zeri, permettere di ottenere esattamente *un cambio di fronte* ogni *colpo di clock* (cosa non vera con sequenze di bit arbitrarie)
]

Utilizzando questo meccanismo, l'utilizzo del canale diventa:
$ U = T_x / (t_x + 2 t_p ?? $
