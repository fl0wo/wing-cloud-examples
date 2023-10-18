bring cloud;
bring http;

let website = new cloud.Website(path: "./front-end/poke-viewer/build");

class PokemonApiResource {

    _baseUrl:str;
    _api: cloud.Api;

    init() {
        this._baseUrl = "https://pokeapi.co/api/v2/pokemon/";
        this._api = new cloud.Api({
            cors: true,
            corsOptions: {
              allowHeaders: ["*"],
              allowMethods: [http.HttpMethod.GET],
            },
          });

        this._api.get("/pokemon/{pokemonName}", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
           let pokemonName = req.vars.get("pokemonName");
           let response = this.getPokemon(pokemonName);
           return {
                status: response.status,
                body: response.body
           };
        });

        this._api.get("/pokemon-list", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
           let response = this.listPokemons();
           return {
                status: response.status,
                body: response.body
           };
        });

    }

    inflight getPokemon(pokemonName:str):http.Response {
        log("Fetching pokemon: ${pokemonName}");
        let url = "${this._baseUrl}${pokemonName}";
        let response = http.get(url);
        return response;
    }

    inflight listPokemons():http.Response {
        log("Fetching pokemon list");
        let url = "${this._baseUrl}?limit=100";
        let response = http.get(url);
        return response;
    }
}


new PokemonApiResource();