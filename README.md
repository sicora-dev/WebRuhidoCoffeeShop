<p align="center">
    <h1 align="center">WEBRUHIDOCOFFEESHOP</h1>
</p>
<p align="center">
    <em><code>❯ REPLACE-ME</code></em>
</p>
<p align="center">
	<img src="https://img.shields.io/github/license/sicora-pixel/WebRuhidoCoffeeShop?style=flat&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
	<img src="https://img.shields.io/github/last-commit/sicora-pixel/WebRuhidoCoffeeShop?style=flat&logo=git&logoColor=white&color=0080ff" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/sicora-pixel/WebRuhidoCoffeeShop?style=flat&color=0080ff" alt="repo-top-language">
	<img src="https://img.shields.io/github/languages/count/sicora-pixel/WebRuhidoCoffeeShop?style=flat&color=0080ff" alt="repo-language-count">
</p>
<p align="center">
		<em>Built with the tools and technologies:</em>
</p>
<p align="center">
	<img src="https://img.shields.io/badge/HTML5-E34F26.svg?style=flat&logo=HTML5&logoColor=white" alt="HTML5">
	<img src="https://img.shields.io/badge/CSS3-1572B6.svg?style=flat&logo=CSS3&logoColor=white" alt="CSS3">
	<img src="https://img.shields.io/badge/JavaScript-F7DF1E.svg?style=flat&logo=JavaScript&logoColor=black" alt="JavaScript">
	<img src="https://img.shields.io/badge/PHP-777BB4.svg?style=flat&logo=PHP&logoColor=white" alt="PHP">
	<img src="https://img.shields.io/badge/JSON-000000.svg?style=flat&logo=JSON&logoColor=white" alt="JSON">
</p>

<br>

##### 🔗 Table of Contents

- [📍 Overview](#-overview)
- [👾 Features](#-features)
- [📂 Repository Structure](#-repository-structure)
- [🧩 Modules](#-modules)
- [🚀 Getting Started](#-getting-started)
    - [🔖 Prerequisites](#-prerequisites)
    - [📦 Installation](#-installation)
    - [🤖 Usage](#-usage)
- [🤝 Contributors](#-contributors)

---

## 📍 Overview

The WebRuhidoCoffeeShop is an online coffee shop platform that allows users to browse, select, and purchase various coffee products. It provides a user-friendly interface for customers to manage their accounts and explore different types of coffee and related merchandise.


---

## 👾 Features

- **Online Store**: Purchase coffee products with a dynamic shopping cart.  
- **User Registration**: Customers can create a personal account to save their preferences and make purchases.  
- **Login**: Registered users can log into their accounts.  
- **Password Recovery**: In case of a forgotten password, it can be recovered using **PHPMailer**.  
- **Cafe Locations**: A section dedicated to showing all physical locations of our cafes.  
- **User Interface**: Intuitive and user-friendly design to facilitate navigation and purchasing.  
- **Shopping Cart**: Functionality to add products to the cart and proceed to checkout.  



---

## 📂 Repository Structure

```sh
└── WebRuhidoCoffeeShop/
    ├── LICENSE
    ├── README.md
    ├── VERSION
    ├── academy.php
    ├── account.php
    ├── bbdd_script_final.sql
    ├── carrito.php
    ├── check_auth.php
    ├── composer.json
    ├── db_conn.php
    ├── divUsuario.php
    ├── footer.php
    ├── forgotpass.php
    ├── get_oauth_token.php
    ├── images
    │   ├── .DS_Store
    │   ├── LAGUNA.png
    │   ├── OlssønBarbieri _.jpeg
    │   ├── RUHIDO Blanco.png
    │   ├── RUHIDO Negro.png
    │   ├── Server backup icon.jpeg
    │   ├── Stereoscope Specialty Coffee Roaster.jpeg
    │   ├── aeropress.jpg
    │   ├── americano.jpg
    │   ├── basic.png
    │   ├── bialetti.jpg
    │   ├── bialetti2.jpg
    │   ├── burundi.jpg
    │   ├── cafeKilo.jpg
    │   ├── cafeSolo.jpg
    │   ├── cafeengrano2.jpg
    │   ├── camiseta.jpg
    │   ├── carrito.png
    │   ├── catacafe1.jpg
    │   ├── catacafe2.jpg
    │   ├── catacafe3.jpg
    │   ├── cofeeHousesBlanco.png
    │   ├── cofeeHousesNegro.png
    │   ├── colombiaCh.jpg
    │   ├── cursoEspresso.jpeg
    │   ├── descafeinado.jpg
    │   ├── espresso1.jpg
    │   ├── espresso3.jpg
    │   ├── espresso4.jpg
    │   ├── fellow.jpg
    │   ├── filtro1.jpg
    │   ├── filtro2.jpg
    │   ├── filtro3.jpg
    │   ├── filtro4.jpg
    │   ├── gorra.jpg
    │   ├── gorraPortada.jpg
    │   ├── imagenOficina.jpeg
    │   ├── lamarzocco.jpg
    │   ├── lateArt4.jpg
    │   ├── latteArt barista2.jpg
    │   ├── local12.jpg
    │   ├── local14.jpg
    │   ├── local16.jpg
    │   ├── local17.jpg
    │   ├── locations.jpg
    │   ├── molinillo.jpg
    │   ├── notNeutral VERO Cortado Glass (4_25oz_125ml) - Clear.jpeg
    │   ├── notion office.jpeg
    │   ├── oficina2.jpg
    │   ├── peru.jpg
    │   ├── portada.jpeg
    │   ├── portada2.jpeg
    │   ├── pro.png
    │   ├── rosal.jpg
    │   ├── saint jean 🌷.jpeg
    │   ├── shopBlack.png
    │   ├── shotEspresso.jpg
    │   ├── taza.jpg
    │   ├── toteBag2.png
    │   ├── us.jpg
    │   ├── v60.jpg
    │   ├── v60bascula.jpg
    │   └── v60taza.jpg
    ├── index.php
    ├── language
    │   ├── phpmailer.lang-af.php
    │   ├── phpmailer.lang-ar.php
    │   ├── phpmailer.lang-as.php
    │   ├── phpmailer.lang-az.php
    │   ├── phpmailer.lang-ba.php
    │   ├── phpmailer.lang-be.php
    │   ├── phpmailer.lang-bg.php
    │   ├── phpmailer.lang-bn.php
    │   ├── phpmailer.lang-ca.php
    │   ├── phpmailer.lang-cs.php
    │   ├── phpmailer.lang-da.php
    │   ├── phpmailer.lang-de.php
    │   ├── phpmailer.lang-el.php
    │   ├── phpmailer.lang-eo.php
    │   ├── phpmailer.lang-es.php
    │   ├── phpmailer.lang-et.php
    │   ├── phpmailer.lang-fa.php
    │   ├── phpmailer.lang-fi.php
    │   ├── phpmailer.lang-fo.php
    │   ├── phpmailer.lang-fr.php
    │   ├── phpmailer.lang-gl.php
    │   ├── phpmailer.lang-he.php
    │   ├── phpmailer.lang-hi.php
    │   ├── phpmailer.lang-hr.php
    │   ├── phpmailer.lang-hu.php
    │   ├── phpmailer.lang-hy.php
    │   ├── phpmailer.lang-id.php
    │   ├── phpmailer.lang-it.php
    │   ├── phpmailer.lang-ja.php
    │   ├── phpmailer.lang-ka.php
    │   ├── phpmailer.lang-ko.php
    │   ├── phpmailer.lang-lt.php
    │   ├── phpmailer.lang-lv.php
    │   ├── phpmailer.lang-mg.php
    │   ├── phpmailer.lang-mn.php
    │   ├── phpmailer.lang-ms.php
    │   ├── phpmailer.lang-nb.php
    │   ├── phpmailer.lang-nl.php
    │   ├── phpmailer.lang-pl.php
    │   ├── phpmailer.lang-pt.php
    │   ├── phpmailer.lang-pt_br.php
    │   ├── phpmailer.lang-ro.php
    │   ├── phpmailer.lang-ru.php
    │   ├── phpmailer.lang-si.php
    │   ├── phpmailer.lang-sk.php
    │   ├── phpmailer.lang-sl.php
    │   ├── phpmailer.lang-sr.php
    │   ├── phpmailer.lang-sr_latn.php
    │   ├── phpmailer.lang-sv.php
    │   ├── phpmailer.lang-tl.php
    │   ├── phpmailer.lang-tr.php
    │   ├── phpmailer.lang-uk.php
    │   ├── phpmailer.lang-ur.php
    │   ├── phpmailer.lang-vi.php
    │   ├── phpmailer.lang-zh.php
    │   └── phpmailer.lang-zh_cn.php
    ├── locations.php
    ├── login.php
    ├── logout.php
    ├── menunav.php
    ├── newpass.php
    ├── producto.php
    ├── productos.php
    ├── profile.php
    ├── register.php
    ├── resetmail.php
    ├── resetpass.php
    ├── scriptShopRuhido.js
    ├── shop.php
    ├── src
    │   ├── DSNConfigurator.php
    │   ├── Exception.php
    │   ├── OAuth.php
    │   ├── OAuthTokenProvider.php
    │   ├── PHPMailer.php
    │   ├── POP3.php
    │   └── SMTP.php
    ├── stylesRuhido.css
    ├── suscriptions.php
    └── us.php
    
```


---

## 🧩 Modules

<details closed><summary>.</summary>

| File | Summary |
| --- | --- |
| [VERSION](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/VERSION) | <code>❯ REPLACE-ME</code> |
| [locations.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/locations.php) | <code>❯ REPLACE-ME</code> |
| [index.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/index.php) | <code>❯ REPLACE-ME</code> |
| [newpass.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/newpass.php) | <code>❯ REPLACE-ME</code> |
| [footer.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/footer.php) | <code>❯ REPLACE-ME</code> |
| [stylesRuhido.css](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/stylesRuhido.css) | <code>❯ REPLACE-ME</code> |
| [login.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/login.php) | <code>❯ REPLACE-ME</code> |
| [resetpass.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/resetpass.php) | <code>❯ REPLACE-ME</code> |
| [carrito.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/carrito.php) | <code>❯ REPLACE-ME</code> |
| [producto.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/producto.php) | <code>❯ REPLACE-ME</code> |
| [scriptShopRuhido.js](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/scriptShopRuhido.js) | <code>❯ REPLACE-ME</code> |
| [account.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/account.php) | <code>❯ REPLACE-ME</code> |
| [academy.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/academy.php) | <code>❯ REPLACE-ME</code> |
| [productos.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/productos.php) | <code>❯ REPLACE-ME</code> |
| [shop.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/shop.php) | <code>❯ REPLACE-ME</code> |
| [check_auth.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/check_auth.php) | <code>❯ REPLACE-ME</code> |
| [us.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/us.php) | <code>❯ REPLACE-ME</code> |
| [bbdd_script_final.sql](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/bbdd_script_final.sql) | <code>❯ REPLACE-ME</code> |
| [suscriptions.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/suscriptions.php) | <code>❯ REPLACE-ME</code> |
| [resetmail.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/resetmail.php) | <code>❯ REPLACE-ME</code> |
| [get_oauth_token.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/get_oauth_token.php) | <code>❯ REPLACE-ME</code> |
| [profile.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/profile.php) | <code>❯ REPLACE-ME</code> |
| [logout.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/logout.php) | <code>❯ REPLACE-ME</code> |
| [menunav.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/menunav.php) | <code>❯ REPLACE-ME</code> |
| [db_conn.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/db_conn.php) | <code>❯ REPLACE-ME</code> |
| [forgotpass.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/forgotpass.php) | <code>❯ REPLACE-ME</code> |
| [register.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/register.php) | <code>❯ REPLACE-ME</code> |
| [divUsuario.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/divUsuario.php) | <code>❯ REPLACE-ME</code> |
| [composer.json](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/composer.json) | <code>❯ REPLACE-ME</code> |

</details>

<details closed><summary>language</summary>

| File | Summary |
| --- | --- |
| [phpmailer.lang-sk.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-sk.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ru.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ru.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ko.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ko.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-sr.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-sr.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-de.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-de.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-tr.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-tr.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-sl.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-sl.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-fa.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-fa.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-hr.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-hr.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-as.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-as.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-he.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-he.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-el.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-el.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ka.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ka.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-tl.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-tl.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-si.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-si.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ja.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ja.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-pt.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-pt.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-cs.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-cs.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-be.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-be.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-uk.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-uk.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-pl.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-pl.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-sr_latn.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-sr_latn.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-id.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-id.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-nl.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-nl.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-fr.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-fr.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-hi.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-hi.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-zh.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-zh.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-pt_br.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-pt_br.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-et.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-et.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-hu.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-hu.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ar.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ar.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-it.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-it.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-mn.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-mn.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ur.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ur.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ca.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ca.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-az.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-az.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-zh_cn.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-zh_cn.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-gl.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-gl.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-fo.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-fo.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-eo.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-eo.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-fi.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-fi.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-sv.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-sv.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-hy.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-hy.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-bn.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-bn.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ro.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ro.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ba.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ba.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-nb.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-nb.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-af.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-af.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-lv.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-lv.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-es.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-es.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-mg.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-mg.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-da.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-da.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-lt.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-lt.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-bg.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-bg.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-ms.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-ms.php) | <code>❯ REPLACE-ME</code> |
| [phpmailer.lang-vi.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/language/phpmailer.lang-vi.php) | <code>❯ REPLACE-ME</code> |

</details>

<details closed><summary>src</summary>

| File | Summary |
| --- | --- |
| [PHPMailer.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/PHPMailer.php) | <code>❯ REPLACE-ME</code> |
| [Exception.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/Exception.php) | <code>❯ REPLACE-ME</code> |
| [DSNConfigurator.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/DSNConfigurator.php) | <code>❯ REPLACE-ME</code> |
| [SMTP.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/SMTP.php) | <code>❯ REPLACE-ME</code> |
| [POP3.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/POP3.php) | <code>❯ REPLACE-ME</code> |
| [OAuth.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/OAuth.php) | <code>❯ REPLACE-ME</code> |
| [OAuthTokenProvider.php](https://github.com/sicora-pixel/WebRuhidoCoffeeShop/blob/main/src/OAuthTokenProvider.php) | <code>❯ REPLACE-ME</code> |

</details>

---

## 🚀 Getting Started

### 🔖 Prerequisites

**PHP**: `version >=5.5.0`

### 📦 Installation

Build the project from source:

1. Clone the WebRuhidoCoffeeShop repository:
```sh
❯ git clone https://github.com/sicora-pixel/WebRuhidoCoffeeShop
```

2. Navigate to the project directory:
```sh
❯ cd WebRuhidoCoffeeShop
```

3. Install the required dependencies:
```sh
❯ composer install
```

### 🤖 Usage

To run the project, execute the following command:

```sh
❯ php main.php
```

## 🤝 Contributors

- **Angela**: 
    - [LinkedIn](https://www.linkedin.com/in/angela) 
    - [GitHub](https://github.com/angela)
- **Ivan**: 
    - [LinkedIn](https://www.linkedin.com/in/ivan) 
    - [GitHub](https://github.com/ivan)

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="left">
   <a href="https://github.com/sicora-dev/WebRuhidoCoffeeShop/graphs/contributors">
      <img src="https://contrib.rocks/image?repo=sicora-pixel/WebRuhidoCoffeeShop">
   </a>
</p>
</details>
