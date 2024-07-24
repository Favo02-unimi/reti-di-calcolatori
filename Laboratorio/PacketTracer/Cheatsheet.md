# Cheatsheet packet tracer

- Options > Preferences > Always show port labes in logica workspace
- Salvare configurazione router e switch (**altrimenti quando li spegni perdono tutto**): tasto save dentro al router/switch (o `write mem`)
- Interrompere esecuzione comando da CLI: `<CTRL+C>` o `<CTRL+SHIFT+6>`
- Dumpare tutta la configurazione: `show running-config`
- Spammare il comando `?` per vedere i comandi della CLI (fatto abbastanza bene)
- `enable` per diventare root

## Reti router/router e router/switch

- Fare subnetting anche per le reti tra router, in subnet/30
- Tra router e switch usare VLAN trunk
- Tra router e router configurare gli IP statici (calcolati nel subnetting)

## VLAN

- Dallo switch:
  - VLAN database per aggiungere VLAN
    - lasciare la 1 ma non usarla
    - usare ID univoci in tutta la rete, non solo nello stesso switch
    - etichettare le porte con la VLAN corretta

- Dal router:
	- creare una virtual interface
    - `config`
    - `interface GigaEthernet <porta verso lo switch>.<ID VLAN>` (ad esempio `GigaEthernet 3/0.2`)
  - da dentro quell'interfaccia impostare standard e dargli IP
    - `encapsulate dot1Q <ID VLAN>`
    - `ip address <gatewayVLAN> <subnetmask>` (calcolati nel subnetting)

## DHCP

- impostare il server DHCP
  - pool, subnet, numero host (calcolati nel subnetting)

- se il server DHCP è in un'altra rete rispetto a dove vuole distribuire IP:
  - andare nel router
  - selezionare interfaccia dove si vuole distribuire gli IP (non dove c'è il server)
    - `interface GigaEthernet <porta>.<ID VLAN>` (ad esempio `GigaEthernet 3/0.2`)
  - mandare le richieste in broadcast all'IP del DHCP: `ip helper-address <ip-server-dhcp>`

## Routing RIP

- dai router (tutti):
  - `config`
  - `router rip`
    - `version 2`
    - per ogni rete adiacente: `network <IP base rete adiacente>`
    - non inondare le LAN di messaggi di controllo: `passive-interface GigaEthernet <porta senza router>` (se ci sono delle VLAN farlo anche per quelle porte, ad esempio `GigaEthernet 3/0.2`)

## Routing OSPF

- dai router (tutti):
  - `config`
  - `router ospf 1`
    - `area 1 stub`
    - per ogni rete adiacente: `network <IP base rete adiacente> <wildcard>`
    - non inondare le LAN di messaggi di controllo: `passive-interface GigaEthernet <porta senza router>` (se ci sono delle VLAN farlo anche per quelle porte, ad esempio `GigaEthernet 3/0.2`)

## Webserver

- disattivare tutti i servizi
- lasciare attivo solo http

## ACL (singola regola)

- `ip access-list <numero> permit <protocollo> <IP sorgente (di solito rete a sinistra)> <wildcard> host <IP destinazione> eq <porta>`

_In caso si volesse filtrare non sulla porta ma su altro si spamma il bellissimo `?` e ci si arrangia!_

## ACL (extended)

- `ip access-list extended <numero>` (il numero deve essere tra 100-199, spammare `?` per vedere queste limitazioni)
- poi una o più regole:
  - `permit <protocollo> <IP sorgente (di solito rete a sinistra)> <wildcard> host <IP destinazione> eq <porta>`

_In caso si volesse filtrare non sulla porta ma su altro si spamma il bellissimo `?` e ci si arrangia!_

## NAT

- dal router di confine tra area privata e pubblica:
  - `config`
    - `interface <interna>` (imposti rete interna)
      - `ip nat inside`
      - `exit`
    - `interface <esterna>` (imposti rete esterna)
      - `ip nat outside`
      - `exit`
    - configurare una acl con indirizzi interni che hanno il permesso di essere tradotti
      - `ip access-list <numeroacl> permit <indirizzi interni (di solito base della rete interna)> <wildcard>`
    - creare pool di indirizzi esterni a cui tradurre
      - `ip nat pool <nomepool> <indirizzo esterno> netmask <netmask>`
    - assegnare acl al pool

# SALVARE!
