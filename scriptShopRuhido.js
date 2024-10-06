







function printCafesShop(id,nombre, descripcion, precio, imagen){
	const cajaCafes = document.getElementById('cointainerRetail');
	console.log('caja', cajaCafes);
	
	const aProduct = document.createElement('a');
	aProduct.href = `producto.php?productId=${id}`;
	const divContainerProduct = document.createElement('div');
	divContainerProduct.classList.add('containerProduct');
	const imgProduct = document.createElement('div');
	imgProduct.classList.add('imgContainer');

	imgProduct.innerHTML = `<img src="${imagen}" alt="imagen del producto">`;


	const divDescriptionProduct = document.createElement('div');
	divDescriptionProduct.classList.add('descriptionProduct');
	const divDescElements = document.createElement('div');
	divDescElements.classList.add('descElements');
	divDescElements.innerHTML = `<div class="nameOrRoasted">
									<div>${nombre}</div>
								</div>
								<div class="descripciones">${descripcion}</div>                            
								<div>${precio}</div>`
	;

	divDescriptionProduct.appendChild(divDescElements);
	divContainerProduct.appendChild(imgProduct);
	divContainerProduct.appendChild(divDescriptionProduct);
	aProduct.appendChild(divContainerProduct);
	
	console.log(aProduct);
	console.log(cajaCafes);
	cajaCafes.appendChild(aProduct);
}


function printEquipShop(id, nombre, descripcion, precio, imagen){ 
		const cajaEqui = document.getElementById('cointainerEquipment');
		console.log('caja', cajaEqui);
		
		const aProduct = document.createElement('a');
		aProduct.href = `producto.php?productId=${id}`;
		const divContainerProduct = document.createElement('div');
		divContainerProduct.classList.add('containerProduct');
		const imgProduct = document.createElement('div');
		imgProduct.classList.add('imgContainer');

		imgProduct.innerHTML = `<img src="${imagen}" alt="imagen del producto">`;

		const divDescriptionProduct = document.createElement('div');
		divDescriptionProduct.classList.add('descriptionProduct');
		const divDescElements = document.createElement('div');
		divDescElements.classList.add('descElements');
		divDescElements.innerHTML = `<div class="nameOrRoasted">
										<div>${nombre}</div>
									</div>
									<div class="descripciones">${descripcion}</div>                            
									<div>${precio}</div>`
		;

		divDescriptionProduct.appendChild(divDescElements);
		divContainerProduct.appendChild(imgProduct);
		divContainerProduct.appendChild(divDescriptionProduct);
		
		aProduct.appendChild(divContainerProduct);
		console.log(aProduct);
		console.log(cajaEqui);
		cajaEqui.appendChild(aProduct);
}

