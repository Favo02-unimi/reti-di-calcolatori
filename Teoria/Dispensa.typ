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

Composto da:
- code di ingresso e uscita (buffer)
- scheduler: decide quale e quando esaminare un pacchetto
- interprete: analizza un pacchetto e lo manda su una coda di uscita

=== Mezzi trasmissivi (cavi)

- Rame/Coassiale/Telefono: $2 dot 10^8 space b p s$
- Fibra: $3 dot 10^8 space b p s$

== Regole di una rete: protocolli

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

===== Carrier Sense Multiple Access with Collision Detection (CSMA-CD)

#informalmente[
  Si effettua CS: se il canale è vuoto si trasmette, altrimenti si aspetta.

  Quando avviene una collisione, allora si interrompe subito la trasmissione e si aspetta tempo randomico che aumenta esponenzialmente (BEB, spiegato sotto) (per 15 volte, dopo si abortisce la comunicazione)
]

#attenzione[
  Per poter rilevare una collisione, il tempo di trasmissione deve essere maggiore della propagazione:
  $ t_x > 2 t_p $
  #informalmente[
    Altrimenti la stazione non sa se a collidere è stato un suo frame o meno
  ]
]

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

== Transmission Control Protocol (TCP)

=== Header e Pseudoheader TCP

=== Fasi della connessione

==== Apertura: three way handshake

==== Comunicazione

===== Controllo del flusso

====== Finestra di ricezione (Window Size) $W_s$

====== Persistent timer

====== Keep alive timer

====== Silly Window Syndrome: Algoritmo di Clark

https://en.wikipedia.org/wiki/Silly_window_syndrome

min(1/2 \* buiffersize, MaximumSegmentSize)

====== Cumulative ACK

====== Delayed ACK: Algoritmo di Nagle

Timer di piggybacking

https://en.wikipedia.org/wiki/Nagle's_algorithm

===== Gestione degli errori

====== Retrasmission Timeout (RTO)

====== Retransmission ambiguity problem: politica di Karn

====== Fast retrasmission

Rimanda il segmento quando riceve tre ACK duplicati, prima che il RTO scada

https://superuser.com/questions/267729/tcp-retransmission-vs-tcp-fast-retransmission

====== Timestamp

===== Controllo della congestione: finestra di congestione $W_c$

- Slow start fino a Slow Start Treshold SST
- Congestione advoidance
- Constant

Errori:

- scade il timer RTO
- ACK duplicati

==== Chiusura

===== Four way close

#figure(caption: "TCP 4 way close")[#image("imgs/tcp-four-way-close.png", width: 40%)]

===== Three way close

===== Half close

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












#pagebreak()
// numerazione appendici
#set heading(numbering: "A.1.")
#counter(heading).update(0)

= Lista acronimi

- FQDN: Fully Qualified Domain Name

= Esercizi

#pagebreak()
#pagebreak()

#line(length: 100%)
= #text(size: 20pt, top-edge: 50pt)[APPUNTI "VECCHI" DA SMISTARE:]

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
