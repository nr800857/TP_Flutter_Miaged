# miaged

TP flutter MIAGED

## Fonctionnalités 

### Page Login

* Connexion avec firebase 
* Mot de passe offusqué 

Compte de test :
mail : mail@test.com  
mdp : test

* Si mauvais mot de passe un message d'erreur s'affiche 
* Si mot de passe oublié : au clic bouton une nouvelle page s'ouvre avec un moyen de récupéré son mot de passe 
* Possibilité de s'inscrire en cliquant sur le bouton -> ajout d'un user dans la database 

### Page Accueil
* Sur page accueil visualisation de la liste de tout les articles dans la base qui ne sont pas ceux de l'utilisateur connecté 
* Moyen de filtrer la liste de vêtement selon le type 
* Au clic sur un vêtement le détail est affiché
* Barre de navigation pour passé de la liste de vêtements au panier et au paramètre profile 

### Détail articles 
* Sur le détail d'un article toutes les informations et l'image est affiché 
* Si l'article n'est pas dans le panier le bouton permet de l'ajouter 
* Si l'article est déjà dans le panier possibilité de le retirer 
*Si l'article est celui de l'utilisateur connecté possiblité de le supprimer de la base 

### Panier 
* Liste des articles présent dans le panier de l'utilisateur est affiché 
* Possibilité de le supprimer avec un bouton 
* Total des articles affiché 
* Prix total affiché 

### Paramètre profil
* Liste des vêtements proposé/vendu par l'utilisateur connecté est affiché 
* Possibilité d'ajouter un article à la database qui sera affiché pour un autre user
* Onglet en haut pour passer des articles de l'user a ses informations 
* Possibilité de changé ses données user et de les sauvergarder 
* Bouton de déconnexion 

