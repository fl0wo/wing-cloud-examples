<script>
    const BASE_URL = `http://127.0.0.1:40183`;

    import {onMount} from "svelte";
    let pokemons = []
    let selectedPokemon = null;
    let imgInterval = null;

    onMount(async () => {
        pokemons = (await getPokemons()).results;
    });
    async function getPokemons() {
        const res = await fetch(`${BASE_URL}/pokemon-list`);
        const text = await res.text();

        if (res.ok) {
            return JSON.parse(text);
        } else {
            throw new Error(text);
        }
    }

    async function getPokemon(pokemonName){
        const res = await fetch(`${BASE_URL}/pokemon/${pokemonName}`);
        const text = await res.text();

        if (res.ok) {
            return JSON.parse(text);
        } else {
            throw new Error(text);
        }
    }

    async function fetchPokemonDetails(pokemonName) {
        selectedPokemon = await getPokemon(pokemonName);
        let i = 0;

        if(imgInterval!==null) clearInterval(imgInterval);

        const swapImg = ()=>{
            const allFaces = [
                selectedPokemon.sprites.front_default,
                selectedPokemon.sprites.back_default,
                selectedPokemon.sprites.front_shiny,
                selectedPokemon.sprites.back_shiny
            ].filter(x=>x!==null);
            selectedPokemon.image = allFaces[i++%4];
        }
        swapImg();
        imgInterval = setInterval(swapImg, 350);
    }

</script>

<h1>Pokemon Viewer</h1>
<p>Fetched pokemons:</p>

{#await pokemons}
    <p>...waiting</p>
{:then allPokemons}
    <div>
        {#each allPokemons as pokemon}

            <div on:click|once={()=>fetchPokemonDetails(pokemon.name)} class="pok-item">
                {pokemon.name}
            </div>

            {#if !!selectedPokemon && pokemon.name===selectedPokemon?.name}
                <div class="d-flex">
                    <div>
                        <p>Height: {selectedPokemon.height}</p>
                        <p>Weight: {selectedPokemon.weight}</p>
                        <p>Base experience: {selectedPokemon.base_experience}</p>
                        <p>Abilities:</p>
                        <ul>
                            {#each selectedPokemon.abilities as ability}
                                <li>{ability.ability.name}</li>
                            {/each}
                        </ul>
                    </div>

                    <div>
                        <!-- all images -->
                        <img class="pok-img" src={selectedPokemon.image} alt="front_default"/>
                    </div>
                </div>
            {/if}

        {/each}
    </div>
{:catch error}
    <p style="color: red">{error.message}</p>
{/await}

<style>
    .pok-item {
        border: 1px solid black;
        padding: 10px;
        margin: 10px;
        background: lightblue;
        font-family: "Abyssinica SIL", serif;
        font-size: 20px;
    }

    .pok-item:hover {
        background: lightgreen;
        transform: scale(1.01);
        cursor: pointer;
    }

    .d-flex{
        display: flex;
        flex-direction: row;
        justify-items: center;
        align-items: center;
        padding-left: 2rem;
    }

    .pok-img{
        width: 200px;
        height: 200px;
    }
</style>