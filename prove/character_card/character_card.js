const aCharacter = {
    name: 'Snortleblat',
    logo: 'snortleblat.webp',
    stats: [
        {class: 'Swamp Beast Diplomat',
        level: 5, 
        health: 100}
    ],
    // when the character is attacked, 20 points are subtracted from the health property value
    attacked: function(){ 
        this.stats[0].health -=20;
        if (this.stats[0].health > 0){
            this.stats[0].health -=0;
        }
        else{
            alert("Character is Dead")
        }
        renderStats(this.stats);
    },
// when clicked, the method will add 1 to the level property value
    levelUp: function () { 
        this.stats[0].level += 1;
        renderStats(this.stats);        
    }
};

document.querySelector('#characterName').textContent = aCharacter.name;

/* how to get the image to display... */
document.querySelector('img').setAttribute('src', aCharacter.logo);
document.querySelector('img').setAttribute('alt', aCharacter.name);
document.querySelector('img').style.width = '400px';

// Let's try a different way to display the stats of the character:

function statTemplate(stat){
    return`
    <tr><td>Class:</td><td>${stat.class}</td></tr>
    <tr><td>Level:</td><td>${stat.level}</td></tr>
    <tr><td>Health:</td><td>${stat.health}</td></tr>
    `;
}

function renderStats(stats){
    const html = stats.map(statTemplate);
    document.querySelector('#sections').innerHTML = html.join("");
}

renderStats(aCharacter.stats);

document.querySelector("#attacked").addEventListener("click", function () {
    aCharacter.attacked()
});

document.querySelector("#level_up").addEventListener("click", function (){
    aCharacter.levelUp()
});