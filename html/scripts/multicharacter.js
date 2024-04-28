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

class CharacterCreation {
    constructor() {
        this.characters = [];
        this.multi_character = true;
        this.max_chars = 5;
        this.default_sex = 'male';
        this.current_char_index = 0;
        this.identity_data = {
            first_name: '',
            last_name: '',
            dob: '',
            sex: this.default_sex,
            nationality: '',
            backstory: '',
        };
        this.creation_step = 0;
        this.creation_steps = 5;
        this.info_active = false;
        this.unique_names = true;
        this.is_name_unique = false;
        this.block_banned_words = true;
        this.banned_words = [ 'hacker' ]; 
        this.allow_tattoos = true;
        this.tattoo_data = {};
        this.tattoo_index = {};
        this.tattoo_areas = [ 'ZONE_HEAD', 'ZONE_TORSO', 'ZONE_LEFT_ARM', 'ZONE_RIGHT_ARM', 'ZONE_LEFT_LEG', 'ZONE_RIGHT_LEG' ];
    }

    init(data) {
        this.characters = (data && data.characters) ? data.characters : [];
        if (this.characters.length === 0 || (this.multi_character && this.characters.length < this.max_chars)) {
            this.characters.push({
                identity: {
                    first_name: 'CREATE',
                    last_name: 'CHARACTER',
                    is_create_option: true
                }
            });
        }
        this.build();
        this.add_listeners();
        if (data && data.values) {
            this.update_input_values(data.values);
        }
    }

    build() {
        $('#main_container').css('box-shadow', 'inset 0px 0px 85px 0px black');
        let buttons_content = '';
        const current_char = this.characters[this.current_char_index];
        if (current_char.identity.is_create_option) {
            buttons_content = `
                <button id="create_button" class="multichar_main_buttons">CREATE</button>
                <button id="help_button" class="multichar_main_buttons">SERVER GUIDE</button>
                <button id="disconnect_button" class="multichar_main_buttons">DISCONNECT</button>  
            `;
        } else {
            buttons_content = `
                <button id="play_button" class="multichar_main_buttons">JOIN SERVER</button>
                <button id="info_button" class="multichar_main_buttons">CHARACTER INFORMATION</button>
                <button id="help_button" class="multichar_main_buttons">SERVER GUIDE</button>
                <button id="disconnect_button" class="multichar_main_buttons">DISCONNECT</button>
            `;
        }
        let header_content = this.characters.length > 1 || current_char.identity.is_create_option ? `
            <div id="panel_header_chevron_left" class="panel_header_chevron"><i class="fa fa-caret-left"></i></div>
            <div class="mc_panel_name">
                <span class="panel_first_name">${current_char.identity.first_name}</span>
                <span class="panel_last_name">${current_char.identity.last_name}</span>
            </div>
            <div id="panel_header_chevron_right" class="panel_header_chevron"><i class="fa fa-caret-right"></i></div>
        ` : `
            <div class="mc_panel_name">
                <span class="panel_first_name">${current_char.identity.first_name}</span>
                <span class="panel_last_name">${current_char.identity.last_name}</span>
            </div>
        `;
        const content = `
            <div id="mc_container">
                <div class="mc_panel">
                    <div class="mc_panel_header">
                        ${header_content}
                    </div>
                    <div class="mc_panel_body">
                        <div class="mc_panel_buttons">
                            ${buttons_content}
                        </div>
                    </div>
                </div>
            </div>
        `;
        $('#main_container').html(content);
        this.toggle_carets_visibility();
    }

    toggle_carets_visibility() {
        if (this.characters.length <= 1 || this.info_active) {
            $('.panel_header_chevron').hide();
        } else {
            $('.panel_header_chevron').show();
        }
    }

    show_character_info(index) {
        if (index >= this.characters.length) {
            const create_html = `
                <div class="create_character_container">
                    <div>Create a new character.</div>
                    <button id="go_back_button" class="multichar_main_buttons">GO BACK</button>
                </div>
            `;
            $('.mc_panel_body').html(create_html);
        } else {
            const char = this.characters[index];
            const info_html = `
                <div class="char_info_tabs">
                    <button class="tab_button active" onclick="show_tab('identity')">Identity</button>
                    <button class="tab_button" onclick="show_tab('stats')">Stats</button>
                </div>
                <div id="identity" class="tab_content" style="display: block;">
                    <div class="tab_inner_container">
                        <div class="char_info_row"><span class="char_label">Name:</span> <span class="char_detail">${capitalize_first_letter(char.identity.first_name)} ${capitalize_first_letter(char.identity.last_name)}</span></div>
                        <div class="char_info_row"><span class="char_label">DOB:</span> <span class="char_detail">${char.identity.dob}</span></div>
                        <div class="char_info_row"><span class="char_label">Sex:</span> <span class="char_detail">${capitalize_first_letter(char.identity.sex)}</span></div>
                        <div class="char_info_row"><span class="char_label">Nationality:</span> <span class="char_detail">${capitalize_first_letter(char.identity.nationality)}</span></div>
                        <div class="char_info_row"><span class="char_label">Unique ID:</span> <span class="char_detail">${char.unique_id}</span></div>
                        <div class="char_info_row"><span class="char_label">Character ID:</span> <span class="char_detail">${char.char_id}</span></div>
                    </div>
                </div>
                <div id="stats" class="tab_content">
                    <div class="tab_inner_container">
                        ${this.show_stats_info(char.stats)}
                    </div>
                </div>
                <button id="play_button" class="multichar_main_buttons">PLAY</button>
                <button id="delete_character_button" class="multichar_main_buttons" data-index="${char.char_id}">DELETE CHARACTER</button>
                <button id="go_back_button" class="multichar_main_buttons">GO BACK</button>
            `;
            $('.mc_panel_body').html(info_html);

            $('#delete_character_button').click(() => {
                this.show_delete_confirmation(char.char_id);
            });
        }
    }

    show_delete_confirmation(char_id) {
        const character = this.characters.find(c => c.char_id === char_id);
        if (!character) {
            return;
        }
        const delete_message = `
            <div class="delete_character_confirmation">
                <div class="tab_inner_container">
                    <div class="char_info_row"><span class="char_label">Confirm deletion of:</span> <span class="char_detail">${capitalize_first_letter(character.identity.first_name)} ${capitalize_first_letter(character.identity.last_name)}</span></div>
                    <div class="delete_char_buttons"> 
                        <button id="confirm_delete_button" class="multichar_delete_buttons" data-char_id="${char_id}">CONFIRM</button>
                        <button id="cancel_delete_button" class="multichar_delete_buttons">CANCEL</button>
                    </div>
                </div>
            </div>
        `;
        $('.tab_content').html(delete_message);

        $('#confirm_delete_button').on('click', () => {
            c$.post(`https://${GetParentResourceName()}/delete_character`, JSON.stringify({
                char_id: char_id
            }));
        });

        $('#cancel_delete_button').on('click', () => {
            const char_index = this.characters.findIndex(c => c.char_id === char_id);
            if (char_index !== -1) {
                this.show_character_info(char_index);
            } else {
                console.error('Character not found');
            }
        });

    }

    go_back_to_main_buttons() {
        if (this.current_char_index === this.characters.length - 1 && this.characters[this.current_char_index].identity.is_create_option) {
            $('.mc_panel_name .panel_first_name').text('Create');
            $('.mc_panel_name .panel_last_name').text('Character');
        }
        this.build();
    }

    show_stats_info(stats) {
        if (!stats || typeof stats !== 'object') {
            return '<div class="char_info_row"><span class="char_label">No stats information available</span></div>';
        }
        return Object.entries(stats).map(([key, value]) => `
            <div class="char_info_row">
                <span class="char_label">${key.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}:</span>
                <span class="char_detail">${value}</span>
            </div>
        `).join('');
    }

    build_toolbar() {
        $('.toolbar').empty();
        const toolbar_content = `
            <div class="toolbar">
                <div class="toolbar_item">
                    <div class="toolbar_icon" id="clothing_icon" data-options="clothing_options"><i class="fa-solid fa-shirt"></i></div>
                    <div class="toolbar_options" data-options="clothing_options">
                        <div data-option="remove_headwear"><i class="fa-solid fa-hat-cowboy-side"></i></div>
                        <div data-option="remove_top"><i class="fa-solid fa-shirt"></i></div>
                        <div data-option="remove_legs"><i class="fa-solid fa-socks"></i></div>
                        <div data-option="remove_shoes"><i class="fa-solid fa-shoe-prints"></i></div>
                    </div>
                </div>
                <div class="toolbar_item">
                    <div class="toolbar_icon" id="camera_icon" data-options="camera_options"><i class="fa-solid fa-video"></i></div>
                    <div class="toolbar_options" data-options="camera_options">
                        <div data-option="default_cam"><i class="fa-solid fa-backward-fast"></i></div>
                        <div data-option="face_cam"><i class="fa-solid fa-face-smile"></i></div>
                        <div data-option="body_cam"><i class="fa-solid fa-person"></i></div>
                        <div data-option="leg_cam"><i class="fa-solid fa-socks"></i></div>
                        <div data-option="feet_cam"><i class="fa-solid fa-shoe-prints"></i></div>
                    </div>
                </div>
                <div class="toolbar_item">
                    <div class="toolbar_icon" id="rotate_icon" data-options="rotate_options"><i class="fa-solid fa-rotate"></i></div>
                    <div class="toolbar_options" data-options="rotate_options">
                        <div data-option="rotate_ped_reset"><i class="fa-solid fa-backward-fast"></i></div>
                        <div data-option="rotate_ped_180"><i class="fa-solid fa-person-rays"></i></div>
                        <div data-option="rotate_ped_left"><i class="fa-solid fa-rotate-left"></i></div>
                        <div data-option="rotate_ped_right"><i class="fa-solid fa-rotate-right"></i></div>
                    </div>
                </div>
            </div>
        `;
        $('#main_container').append(toolbar_content);
    }
    
    show_creation_panel() {
        if (this.creation_step === 2 && !this.allow_tattoos) {
            this.creation_step++;
        }
        if (this.creation_step === 0) {
            this.build_toolbar();
        }    
        $('.mc_panel_body').empty();
        let creation_html = `<div class="creation_character_container">`;
        switch (this.creation_step) {
            case 0:
                $('.mc_panel_name .panel_first_name').text('Character');
                $('.mc_panel_name .panel_last_name').text('Identity');
                creation_html += `
                    <form id="identity_form">
                        <div class="sex_selection_container">
                            <button type="button" id="male_button" name="sex" sex="male" class="sex_button male ${this.default_sex === 'male' ? 'active' : ''}"><i class="fa fa-mars" aria-hidden="true"></i></button>
                            <button type="button" id="female_button" name="sex" sex="female" class="sex_button female ${this.default_sex === 'female' ? 'active' : ''}"><i class="fa fa-venus" aria-hidden="true"></i></button>
                        </div>
                        <input type="text" category="identity" id="first_name" name="first_name" placeholder="First Name" value="${this.identity_data.first_name || ''}">
                        <input type="text" category="identity" id="last_name" name="last_name" placeholder="Last Name" value="${this.identity_data.last_name || ''}">
                        <input type="date" category="identity" id="dob" name="dob" placeholder="Date of Birth" value="${this.identity_data.dob || ''}">
                        <input type="text" category="identity" id="nationality" name="nationality" placeholder="Nationality" value="${this.identity_data.nationality || ''}">
                        <textarea category="identity" id="backstory" name="backstory" placeholder="Backstory">${this.identity_data.backstory || ''}</textarea>
                    </form>
                `;
                break;            
            case 1:
                $('.mc_panel_name .panel_first_name').text('Character');
                $('.mc_panel_name .panel_last_name').text('Genetics');
                creation_html += `
                    <form id="genetics_form">
                        ${genetics_options.map(option => `
                            <div class="option_container">
                                <label for="${option.id}">${option.title}</label>
                                <div class="input_chevron_container">
                                    <button type="button" class="chevron left"><i class="fa fa-chevron-left"></i></button>
                                    <input type="number" category="genetics" id="${option.id}" name="${option.id}" value="0" min="0" max="100">
                                    <button type="button" class="chevron right"><i class="fa fa-chevron-right"></i></button>
                                </div>
                            </div>
                        `).join('')}
                    </form>
                `;
                break;
            case 2:
                this.is_name_unique = false;
                $('.mc_panel_name .panel_first_name').text('Character');
                $('.mc_panel_name .panel_last_name').text('Barber');
                creation_html += `
                <form id="barber_form">
                    ${barber_options.map(option => `
                        <div class="option_container">
                            <label>${capitalize_first_letter(option.id.replace(/_/g, ' '))}</label>
                            <div class="input_chevron_container">
                                <button type="button" class="chevron left"><i class="fa fa-chevron-left"></i></button>
                                <input type="number" category="barber" id="${option.id}" name="${option.id}" value="0" min="0" max="100">
                                <button type="button" class="chevron right"><i class="fa fa-chevron-right"></i></button>
                            </div>
                        </div>
                    `).join('')}
                </form>
                `;
                break;
            case 3:
                this.is_name_unique = false;
                this.init_tattoo_options();
                $('.mc_panel_name .panel_first_name').text('Character');
                $('.mc_panel_name .panel_last_name').text('Tattoos');
                creation_html += `
                    <form id="tattoo_form">
                        ${this.tattoo_areas.map(zone => `
                            <div class="tattoo_option_container">
                                <label for="${zone}">${capitalize_first_letter(zone.replace('ZONE_', '').replace('_', ' '))}</label>
                                <div class="input_chevron_container">
                                    <button type="button" class="chevron left"><i class="fa fa-chevron-left"></i></button>
                                    <input type="text" category="tattoos" id="${zone}" name="${zone}" value="None" readonly>
                                    <button type="button" class="chevron right"><i class="fa fa-chevron-right"></i></button>
                                </div>
                            </div>
                        `).join('')}
                    </form>
                `;
                break;
            case 4:
                this.is_name_unique = false;
                $('.mc_panel_name .panel_first_name').text('Character');
                $('.mc_panel_name .panel_last_name').text('Clothing');
                creation_html += `
                    <form id="clothing_form">
                        ${clothing_options.map(option => `
                            <div class="option_container">
                                <label for="${option.style.id}">${option.title} Style</label>
                                <div class="input_chevron_container">
                                    <button type="button" class="chevron left"><i class="fa fa-chevron-left"></i></button>
                                    <input type="number" category="clothing" id="${option.style.id}" name="${option.style.id}" value="-1" min="-1" max="100">
                                    <button type="button" class="chevron right"><i class="fa fa-chevron-right"></i></button>
                                </div>
                            </div>
                            <div class="option_container">
                            <label for="${option.texture.id}">${option.title} Texture</label>
                                <div class="input_chevron_container">
                                    <button type="button" class="chevron left"><i class="fa fa-chevron-left"></i></button>
                                    <input type="number" category="clothing" id="${option.texture.id}" name="${option.texture.id}" value="-1" min="-1" max="100">
                                    <button type="button" class="chevron right"><i class="fa fa-chevron-right"></i></button>
                                </div>
                            </div>
                        `).join('')}
                    </form>
                `;
                break;
        }
        creation_html += `</div>`;
        if (this.creation_step < this.creation_steps) {
            creation_html += `
                <button id="next_step_button" class="multichar_main_buttons">NEXT</button>
                <button id="prev_step_button" ${this.creation_step === 0 ? 'style="display: none;"' : ''} class="multichar_main_buttons">PREVIOUS</button>
                <button id="go_back_button" class="multichar_main_buttons">CANCEL</button>
            `;
        } else {
            $('.creation_character_container').empty();
            $('.mc_panel_name .panel_first_name').text('Save');
            $('.mc_panel_name .panel_last_name').text('Character');
            creation_html += `
                <button id="save_character_button" class="multichar_main_buttons">SAVE</button>
                <button id="prev_step_button" class="multichar_main_buttons">PREVIOUS</button>
                <button id="go_back_button" class="multichar_main_buttons">CANCEL</button>
            `;
        }
    
        $('.mc_panel_body').html(creation_html);
    }

    init_tattoo_options() {
        const self = this;
        $.getJSON('scripts/json/tattoos.json', function(data) {
            self.tattoo_areas.forEach(zone => {
                self.tattoo_data[zone] = data[zone];
                self.tattoo_index[zone] = 0;
                if (data[zone] && data[zone].length > 0) {
                    $(`#${zone}`).val(data[zone][0].label);
                }
            });
        });
    }

    show_server_guide_panel() {
        const guide_content = `
            <div class="server_guide_container">
                <div class="server_rules_container">
                    <h3>Server Rules</h3>
                    <ul>
                        <li>No griefing or harassment.</li>
                        <li>Respect all players and staff.</li>
                        <li>No cheating or exploiting bugs.</li>
                        <li>Follow roleplay guidelines.</li>
                    </ul>
                </div>
                <div class="keybinds_container">
                    <h3>Keybinds</h3>
                    <table>
                        <tr>
                            <td>F1</td>
                            <td>Open Inventory</td>
                        </tr>
                        <tr>
                            <td>F2</td>
                            <td>Open Phone</td>
                        </tr>
                        <tr>
                            <td>F3</td>
                            <td>Open Emote Menu</td>
                        </tr>
                    </table>
                </div>
            </div>
            <button id="play_button" class="multichar_main_buttons">PLAY</button>
            <button id="go_back_button" class="multichar_main_buttons">GO BACK</button>
        `;
        $('.mc_panel_body').html(guide_content);
    }

    add_listeners() {
        const self = this;
    
        $('#main_container').off().on('click', '#panel_header_chevron_left, #panel_header_chevron_right', function() {
            const direction = $(this).attr('id') === 'panel_header_chevron_right' ? 1 : -1;
            self.current_char_index = (self.current_char_index + direction + self.characters.length) % self.characters.length;
            self.build();
            const chosen_char = self.characters[self.current_char_index];
            if (chosen_char.identity.is_create_option) {
                $.post(`https://${GetParentResourceName()}/select_character`, JSON.stringify({
                    is_create_character: true
                }));
            } else {
                $.post(`https://${GetParentResourceName()}/select_character`, JSON.stringify({
                    sex: chosen_char.identity.sex,
                    style: chosen_char.style
                }));
            }
        });
    
        $('#main_container').on('click', '#play_button', function() {
            const selected_char_id = self.characters[self.current_char_index].char_id;
            $.post(`https://${GetParentResourceName()}/play`, JSON.stringify({
                char_id: selected_char_id
            }));
        });
        
        $('#main_container').on('click', '#info_button', function() {
            self.info_active = true;
            self.toggle_carets_visibility();
            self.show_character_info(self.current_char_index);
        });
    
        $('#main_container').on('click', '#go_back_button', function() {
            if (self.info_active) {
                self.info_active = false;
            }
            self.go_back_to_main_buttons();
        });
        
        $('#main_container').on('click', '#create_button', function() {
            self.creation_step = 0;
            self.show_creation_panel();
        });
        
        $('#main_container').on('click', '#help_button', function() {
            self.show_server_guide_panel();
        });
        
        $('#main_container').on('click', '#disconnect_button', function() {
            $.post(`https://${GetParentResourceName()}/disconnect`, JSON.stringify({}));
        });
    
        $('#main_container').on('click', '.sex_button', function() {
            $('.sex_button').removeClass('active');
            $(this).addClass('active');
            self.default_sex = $(this).attr('sex');
            $.post(`https://${GetParentResourceName()}/change_preview_ped_sex`, JSON.stringify({
                sex: self.default_sex
            }));
        });

        $('#main_container').on('click', '.chevron', function() {
            const input = $(this).siblings('input[type="number"], input[type="text"]');
            let value = parseInt(input.val(), 10);
            value = $(this).hasClass('left') ? value - 1 : value + 1;
            input.val(Math.max(input.attr('min'), Math.min(value, input.attr('max'))));
            input.trigger('change');
        });

        $('#main_container').on('change', 'input[type="number"], input[type="text"], input[type="date"]', function() {
            const category = $(this).attr('category');
            const id = $(this).attr('id');
            let value = $(this).val();
            if (category === 'identity') {
                if (self.identity_data) {
                    self.identity_data[id] = value;
                }
                return;
            }
            if (category === 'tattoos') {
                const current_index = self.tattoo_index[id];
                value = self.tattoo_data[id][current_index] || null;
            }
            $.post(`https://${GetParentResourceName()}/update_value`, JSON.stringify({
                sex: self.default_sex,
                category: category,
                id: id,
                value: value
            }));
        });
        
        
        $('#main_container').on('click', '#next_step_button', function() {
            if (self.creation_step === 0) {
                self.validate_and_proceed();
            } else {
                self.proceed_to_next_step();
            }
        });
        
        $('#main_container').on('click', '#prev_step_button', function() {
            if (self.creation_step > 0) {
                self.creation_step--;
                if (self.creation_step === 2 && !self.allow_tattoos) {
                    self.creation_step--;
                }
                self.show_creation_panel();
            }
        });

        $('#main_container').on('click', '.tattoo_option_container .chevron', function() {
            const container = $(this).closest('.tattoo_option_container');
            const input = container.find('input[type="text"]');
            const zone = input.attr('id');
            if (!(zone in self.tattoo_data)) return;
            let current_index = self.tattoo_index[zone];
            current_index += $(this).hasClass('left') ? -1 : 1;
            current_index = (current_index + self.tattoo_data[zone].length) % self.tattoo_data[zone].length;
            self.tattoo_index[zone] = current_index;
            const tattooLabel = self.tattoo_data[zone][current_index]?.label || 'None';
            input.val(tattooLabel);
        });
        
        $('#main_container').on('click', '#save_character_button', function() {
            console.log('Save character button clicked');
            self.save_character();
        });

        $('#main_container').off('click', '.toolbar_icon').on('click', '.toolbar_icon', function() {
            let options_menu = $(this).next('.toolbar_options');
            if (options_menu.is(':visible')) {
                options_menu.hide();
            } else {
                $('.toolbar_options').hide();
                options_menu.show();
            }
        });
    
        $(document).off('click.toolbar').on('click.toolbar', function(e) {
            if (!$(e.target).closest('.toolbar_item').length) {
                $('.toolbar_options').hide();
            }
        });

        $('#main_container').off('click', '.toolbar_options').on('click', '.toolbar_options', function(e) {
            e.stopPropagation();
        });
    
        $('#main_container').off('click', '.toolbar_options div').on('click', '.toolbar_options div', function() {
            let option = $(this).data('option');
            console.log('Option clicked:', option);
            if (option === 'default_cam' || option === 'face_cam' || option === 'body_cam' || option === 'leg_cam' || option === 'feet_cam') {
                $.post(`https://${GetParentResourceName()}/change_camera_position`, JSON.stringify({value: option}));
            }
            if (option === 'rotate_ped_left' || option === 'rotate_ped_right' || option === 'rotate_ped_180' || option === 'rotate_ped_reset') {
                $.post(`https://${GetParentResourceName()}/rotate_ped`, JSON.stringify({value: option}));
            }
            if (option === 'remove_headwear' || option === 'remove_top' || option === 'remove_legs' || option === 'remove_shoes') {
                $.post(`https://${GetParentResourceName()}/equip_remove_clothing`, JSON.stringify({value: option}));
            }
        });
    }

    save_character() {
        let next_char_id = this.get_next_char_id();
        $.post(`https://${GetParentResourceName()}/create_character`, JSON.stringify({
            char_id: next_char_id,
            first_name: this.identity_data.first_name || $('#first_name').val(),
            last_name: this.identity_data.last_name || $('#last_name').val(),
            dob: this.identity_data.dob || $('#dob').val(),
            sex: this.identity_data.sex || this.default_sex,
            nationality: this.identity_data.nationality || $('#nationality').val(),
            backstory: this.identity_data.backstory || $('#backstory').val(),
        }));
    }
    
    get_next_char_id() {
        if (this.characters.length === 0) {
            return 1;
        } else {
            let max_char_id = this.characters.reduce((max_id, character) => Math.max(max_id, Number(character.char_id || 0)), 0);
            return max_char_id + 1;
        }
    }

    validate_and_proceed() {
        const first_name = $('#first_name').val().toLowerCase();
        const last_name = $('#last_name').val().toLowerCase();
        const backstory = $('#backstory').val().toLowerCase();
        const nationality = $('#nationality').val().toLowerCase();
        if (this.block_banned_words) {
            const text_fields = `${first_name} ${last_name} ${backstory} ${nationality}`;
            const found_words = this.banned_words.filter(word => text_fields.includes(word));
            if (found_words.length > 0) {
                alert(`Your first name, last name, backstory, or nationality contains a banned word/s please remove it!\nBanned word/s: ${found_words.join(", ")}`);
                return;
            }
        }
        if (this.unique_names && !this.is_name_unique) {
            fetch(`https://${GetParentResourceName()}/validate_name`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    first_name: first_name,
                    last_name: last_name
                })
            }).then(resp => resp.json()).then(resp => {
                if (resp.error) {
                    console.error(resp.error);
                } else if (resp.valid) {
                    this.is_name_unique = true;
                    this.proceed_to_next_step();
                }
            });
        } else {
            this.proceed_to_next_step();
        }
    }
    
    proceed_to_next_step() {
        if (this.creation_step < this.creation_steps) {
            this.creation_step++;
            if (this.creation_step === 2 && !this.allow_tattoos) {
                this.creation_step++;
            }
            this.show_creation_panel();
        }
    }

    update_input_values(values) {
        for (const [key, value] of Object.entries(values)) {
            let $input = $("#" + key);
            if ($input.length > 0) {
                $input.attr('min', -1);
                $input.attr('max', value);
            }
        }
    }

    close() {
        $('#main_container').empty();
        $('#main_container').css('box-shadow', 'none');
    }
    
}

// Genetics
const genetics_options = [
    {id: 'mother', title: 'Mother'},
    {id: 'father', title: 'Father'},
    {id: 'resemblance', title: 'Resemblance'},
    {id: 'skin_tone', title: 'Skin Tone'},
    {id: 'eye_colour', title: 'Eye Colour'},
    {id: 'eye_opening', title: 'Eye Opening'},
    {id: 'eyebrow_height', title: 'Eyebrow Height'},
    {id: 'eyebrow_depth', title: 'Eyebrow Depth'},
    {id: 'nose_width', title: 'Nose Width'},
    {id: 'nose_peak_height', title: 'Nose Peak Height'},
    {id: 'nose_peak_length', title: 'Nose Peak Length'},
    {id: 'nose_bone_height', title: 'Nose Bone Height'},
    {id: 'nose_peak_lower', title: 'Nose Peak Lower'},
    {id: 'nose_twist', title: 'Nose Twist'},
    {id: 'cheek_bone', title: 'Cheek Bone'},
    {id: 'cheek_bone_sideways', title: 'Sideways Bone Size'},
    {id: 'cheek_bone_width', title: 'Cheek Bone Width'},
    {id: 'lip_thickness', title: 'Lip Thickness'},
    {id: 'jaw_bone_width', title: 'Jaw Bone Width'},
    {id: 'jaw_bone_shape', title: 'Jaw Bone Shape'},
    {id: 'chin_bone', title: 'Chin Bone'},
    {id: 'chin_bone_length', title: 'Chin Bone Length'},
    {id: 'chin_bone_shape', title: 'Chin Bone Shape'},
    {id: 'chin_hole', title: 'Chin Hole'},
    {id: 'neck_thickness', title: 'Neck Thickness'}
];

// Barber
const barber_options = [
    { id: 'hair', title: 'Hair' },
    { id: 'hair_colour', title: 'Hair Colour' },
    { id: 'fade', title: 'Fade' },
    { id: 'fade_opacity', title: 'Fade Opacity' },
    { id: 'fade_colour', title: 'Fade Colour' },
    { id: 'eyebrow', title: 'Eyebrows' },
    { id: 'eyebrow_opacity', title: 'Eyebrows Opacity' },
    { id: 'eyebrow_colour', title: 'Eyebrows Colour' },
    { id: 'facial_hair', title: 'Facial Hair' },
    { id: 'facial_hair_opacity', title: 'Facial Hair Opacity' },
    { id: 'facial_hair_colour', title: 'Facial Hair Colour' },
    { id: 'chest_hair', title: 'Chest Hair' },
    { id: 'chest_hair_opacity', title: 'Chest Hair Opacity' },
    { id: 'chest_hair_colour', title: 'Chest Hair Colour' },
    { id: 'make_up', title: 'Make Up' },
    { id: 'make_up_opacity', title: 'Make Up Opacity' },
    { id: 'make_up_colour', title: 'Make Up Colour' },
    { id: 'blush', title: 'Blush' },
    { id: 'blush_opacity', title: 'Blush Opacity' },
    { id: 'blush_colour', title: 'Blush Colour' },
    { id: 'lipstick', title: 'Lipstick' },
    { id: 'lipstick_opacity', title: 'Lipstick Opacity' },
    { id: 'lipstick_colour', title: 'Lipstick Colour' },
    { id: 'blemishes', title: 'Blemishes' },
    { id: 'blemishes_opacity', title: 'Blemishes Opacity' },
    { id: 'body_blemishes', title: 'Body Blemishes' },
    { id: 'body_blemishes_opacity', title: 'Body Blemishes Opacity' },
    { id: 'ageing', title: 'Ageing' },
    { id: 'ageing_opacity', title: 'Ageing Opacity' },
    { id: 'complexion', title: 'Complexion' },
    { id: 'complexion_opacity', title: 'Complexion Opacity' },
    { id: 'sun_damage', title: 'Sun Damage' },
    { id: 'sun_damage_opacity', title: 'Sun Damage Opacity' },
    { id: 'moles', title: 'Moles' },
    { id: 'moles_opacity', title: 'Moles Opacity' }
];

// Clothing
const clothing_options = ['mask', 'neck', 'jacket', 'shirt', 'vest', 'legs', 'shoes', 'hands', 'bag', 'decals', 'hats', 'glasses', 'earwear', 'watches', 'bracelets'].map(item => {
    const base_id = item.replace(/ /g, '_');
    return {
        title: capitalize_first_letter(item),
        style: { id: `${base_id}_style`, title: `${capitalize_first_letter(item)} Style` },
        texture: { id: `${base_id}_texture`, title: `${capitalize_first_letter(item)} Texture` }
    };
});

// Changes tabs in the character info section
function show_tab(tab_name) {
    $('.tab_content').css('display', 'none');
    $('.tab_button').removeClass('active');
    $('#' + tab_name).css('display', 'block');
    $('.tab_button').each(function() {
        if (this.getAttribute('onclick') === `show_tab('${tab_name}')`) {
            $(this).addClass('active');
        }
    });
}

// Test data for editing in live previews
const test_data = {
    characters: [
        {
            unique_id: 'BOII_123456',
            char_id: 1,
            identity: {
                first_name: 'John',
                last_name: 'Doe',
                dob: '1990-01-01',
                sex: 'male',
                nationality: 'San Andreas',
                is_create_option: false
            },
            balances: {
                bank: { amount: 10000 },
                cash: { amount: 1500 },
                savings: { amount: 1500 }
            },
            stats: {
                days_played: 0,
                achievements_unlocked: 0,
                vehicles_owned: 0,
                property_owned: 0,
                businesses_owned: 0,
                items_crafted: 0,
                crimes_committed: 0,
                times_arrested: 0,
                enemies_defeated: 0,
                events_participated: 0,
                time_in_safezones: 0,
                died: 0,
                died_by_player: 0,
                died_by_ped: 0,
                died_by_animal: 0,
                respawned: 0,
                revived: 0,
                medical_treatment_received: 0,
                total_spent: 0,
                total_earned: 0,
                legal_money_earned: 0,
                illegal_money_earned: 0,
                job_money_earned: 0,
            }
        }
    ],
    values: {
        hair_color: 5,
        eye_color: 2,
    }
};

/*
let test_multichar = new CharacterCreation()
test_multichar.init(test_data)
*/