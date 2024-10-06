
<div id="carrito" class="carrito"></div>

<div id="carritoLateral" class="carritoLateral oculto">
    <div class="insideCart">
        <div class="encabProductos">PRODUCTOS</div>
        <div id="addedProducts" class="addedProducts"></div>
        <div class="encabTotal">TOTAL</div>
        <div id="total" class="total">0.00€</div>
        <input type="button" value="IR AL PAGO">
        <div id="closeCarrito" class="closeCarritoClass">CLOSE X </div>
    </div>
</div>
<script>

    let closeCarrito;
    let carritoLateral;
    let carrito;
    let addedProducts;
    let totalElement;
    let precioUnidadElement;
    let precioTotalElement;
    let error = '';

        document.addEventListener('DOMContentLoaded', function(event) {
            // Variables necesarias
            closeCarrito = document.getElementById('closeCarrito');
            carritoLateral = document.getElementById('carritoLateral');
            carrito = document.getElementById('carrito');
            addedProducts = document.getElementById('addedProducts');
            totalElement = document.getElementById('total');
            precioUnidadElement = document.getElementById('precioUnidad');
            precioTotalElement = document.getElementById('precioTotal');

            closeCarrito.addEventListener('click', () => {
                carritoLateral.classList.add('oculto');
                error = '';
                renderCart();
            });

            carrito.onclick = function (e) {
                carritoLateral.classList.toggle('oculto');
            }

            // Renderizar el carrito al cargar la página
            renderCart();
        });
            

            

            // Función para manejar el agregar al carrito
            function agregarAlCarrito(name, cantidad, precioUnidad) {
                if(cantidad <=0){
                    let elementoCantidad = getElementById('cantidadDeProducto');
                    elementoCantidad.classList.add = 'placeholderRojo';
                    return;
                }
                const precioTotal = (precioUnidad * cantidad).toFixed(2);

                const product = {
                    name: name,
                    cantidad: cantidad,
                    precioTotal: precioTotal
                };

                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                const existingProductIndex = cart.findIndex(p => p.name === product.name);
                if (existingProductIndex !== -1) {
                    // Update the existing product
                    cart[existingProductIndex].cantidad += product.cantidad;
                    cart[existingProductIndex].precioTotal = (precioUnidad * cart[existingProductIndex].cantidad).toFixed(2);
                } else {
                    // Add new product
                    cart.push(product);
                }
                localStorage.setItem('cart', JSON.stringify(cart));

                renderCart();
                carritoLateral.classList.remove('oculto');
            }

            function renderCart() {
                
                const cart = JSON.parse(localStorage.getItem('cart')) || [];
                if(cart.length === 0){
                    carrito.classList.add('oculto');
                    carritoLateral.classList.add('oculto');
                    return;
                }
                carrito.classList.remove('oculto');
                

                addedProducts.innerHTML = error;

                cart.forEach(product => {
                    const productDiv = document.createElement('div');
                    productDiv.classList.add('productoCarrito');

                    const nameDiv = document.createElement('div');
                    nameDiv.textContent = product.name;

                    const cantidadDiv = document.createElement('div');
                    cantidadDiv.classList.add('cantidadDiv');
                    const btnMenos = document.createElement('button');
                    btnMenos.textContent = '-';
                    btnMenos.onclick = () => actualizarCantidad(productDiv, -1, product.name);

                    const cantidadSpan = document.createElement('span');
                    cantidadSpan.textContent = product.cantidad;

                    const btnMas = document.createElement('button');
                    btnMas.textContent = '+';
                    btnMas.onclick = () => actualizarCantidad(productDiv, 1, product.name);

                    const btnEliminar = document.createElement('button');
                    btnEliminar.textContent = 'Eliminar';
                    btnEliminar.onclick = () => eliminarProducto(product.name);

                    cantidadDiv.appendChild(btnMenos);
                    cantidadDiv.appendChild(cantidadSpan);
                    cantidadDiv.appendChild(btnMas);
                    cantidadDiv.appendChild(btnEliminar);

                    const precioDiv = document.createElement('div');
                    precioDiv.textContent = `${product.precioTotal}€`;

                    productDiv.appendChild(nameDiv);
                    productDiv.appendChild(cantidadDiv);
                    productDiv.appendChild(precioDiv);

                    addedProducts.appendChild(productDiv);
                });

                actualizarTotalCarrito();
            }

            function actualizarCantidad(productDiv, delta, productName) {
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                const productIndex = cart.findIndex(product => product.name === productName);
                if (productIndex !== -1) {
                    let product = cart[productIndex];
                    product.cantidad += delta;
                    if (product.cantidad < 1) {
                        product.cantidad = 1;
                        error = "No puedes tener menos de 1 producto en el carrito";
                        renderCart();
                    }else{
                        error='';
                    }
                    product.precioTotal = (precioUnidad * product.cantidad).toFixed(2);
                    cart[productIndex] = product;
                    localStorage.setItem('cart', JSON.stringify(cart));
                    
                    renderCart();
                }
            }

            function eliminarProducto(productName) {
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                cart = cart.filter(product => product.name !== productName);
                localStorage.setItem('cart', JSON.stringify(cart));
                renderCart();
            }

            function actualizarTotalCarrito() {
                const cart = JSON.parse(localStorage.getItem('cart')) || [];
                let total = cart.reduce((sum, product) => sum + parseFloat(product.precioTotal), 0);
                totalElement.textContent = `${total.toFixed(2)}€`;
            }

    </script>
