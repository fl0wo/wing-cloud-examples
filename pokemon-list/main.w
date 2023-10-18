bring cloud;
bring http;

class PokemonApiResource {

    _baseUrl:str;
    _api: cloud.Api;

    init() {
        this._baseUrl = "https://pokeapi.co/api/v2/pokemon/";
        this._api = new cloud.Api();

        this._api.get("/pokemon/{pokemonName}", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
           let pokemonName = req.vars.get("pokemonName");
           let response = this.getPokemon(pokemonName);
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
}


new PokemonApiResource();