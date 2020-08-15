exports.handler = async function (event, context, callback) {
    const pets = [
        { 
            "id": 1, 
            "type": "dog", 
            "price": 249.99 
        }, 
        { 
            "id": 2, 
            "type": "cat", 
            "price": 124.99 
        }, 
        { 
            "id": 3, 
            "type": "fish", 
            "price": 0.99 
        } 
    ];
    const { petId } = event["pathParameters"] || '';

    console.log('Receieved Pet ID: ', petId);

    const results = pets.filter((pet) => {
        console.log('id: ', pet.id);
        console.log('petId: ', petId);
        console.log('filtering: ', JSON.stringify(pet));
        return pet.id === +petId;
    });


    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json;',
        },
        body: JSON.stringify(results),
    }
    callback(null, response)
}
