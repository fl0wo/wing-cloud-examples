# Pokemon Viewer App

In this example we created a simple website showing some Pokemon data. 
We used the [PokeAPI](https://pokeapi.co/) to fetch the data but using an API proxy with [Winglang](https://www.winglang.io/).

[![Showcase](./poke-showcase.gif)](./poke-showcase.gif)

## Infrastructure With Code

The infrastructure is composed by:  
- A [cloud.Website](https://www.winglang.io/docs/standard-library/cloud/website) to host the website
- A [cloud.Api](https://www.winglang.io/docs/standard-library/cloud/api) as proxy for fetching the data from the PokeAPI
- A [inflight functions](https://www.winglang.io/docs/concepts/inflights) as glue functions for the API

[![IwC](/pokemon-list/infra-poke.png)](/pokemon-list/infra-poke.png)

The infrastructure is defined in the `main.w` file.

## Website

The website is a simple [Svelte](https://svelte.dev/) application.

Note: The port of the cloud.API changes every time you spin up the infrastructure. 
You can find the port in the wing console clicking at the cloud.API node.
Then you can change the port in the `src/routes/+page.svelte` file.


## Custom Resource

```wing
// 👇 here we define it
class PokemonApiResource {

    _baseUrl:str;
    _api: cloud.Api;

    init() {
        ...
    }

    // 👇 we need to specify thats an inflight function as we're running it on a pre-flight context
    inflight getPokemon(pokemonName:str):http.Response {
        ...
    }
    
    // 👇 we need to specify thats an inflight function as we're running it on a pre-flight context
    inflight listPokemons():http.Response {
        ...
    }
}

// 👇 here we deploy it
new PokemonApiResource();
```


