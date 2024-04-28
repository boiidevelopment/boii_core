/*
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|         ROLEPLAY FRAMEWORK BASE
*/

let char_creation = null;

window.addEventListener('message', function (event) {
    let data = event.data;
    if (data.action === 'copy_to_clipboard') {
        copy_to_clipboard(data.string);
    } 
    else if (data.action === 'play_audio') {
        play_audio(data.sound, data.volume);
    } 
    else if (data.action === 'open_char_create') {
        char_creation = new CharacterCreation();
        char_creation.init(data.data);
    } else if (data.action === 'clothing_and_prop_values') {
        if (char_creation) {
            char_creation.update_input_values(data.values);
        }
    } else if (data.action === 'close_char_creation') {
        if (char_creation) {
            char_creation.close();
        }
    }
});

// Creates a new HTML element with optional class and inner HTML
function create_element(element, class_name, inner_html) {
    let new_ele = document.createElement(element);
    if (class_name) new_ele.classList.add(class_name);
    if (inner_html) new_ele.innerHTML = inner_html;
    return new_ele;
}

// Copies a given string to the system clipboard
const copy_to_clipboard = str => {
    const el = create_element('textarea');
    el.value = str;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
};

// Plays an audio file from a given path with specified volume
function play_audio(sound_file, volume) {
    let audio = new Audio(sound_file);
    if (audio != null) {
        audio.pause();
    }
    audio.volume = volume;
    audio.play();
}

// Capitalizes the first letter of each word in a string
function capitalize_first_letter(string) {
    return string.split(' ').map(function(word) {
        return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
    }).join(' ');
}
