Locales['es'] = {
  -- Inventory
  ['inventory'] = 'inventario %s / %s',
  ['use'] = 'usar',
  ['give'] = 'dar',
  ['remove'] = 'tirar',
  ['return'] = 'devolver',
  ['give_to'] = 'dar a',
  ['amount'] = 'cantidad',
  ['giveammo'] = 'dar munición',
  ['amountammo'] = 'cantidad de munición',
  ['noammo'] = 'no tienes suficiente munición!',
  ['gave_item'] = 'diste ~y~%sx~s~ ~b~%s~s~ a ~y~%s~s~',
  ['received_item'] = 'recibiste ~y~%sx~s~ ~b~%s~s~ de ~b~%s~s~',
  ['gave_weapon'] = 'diste ~b~%s~s~ a ~y~%s~s~',
  ['gave_weapon_ammo'] = 'diste ~o~%sx %s~s~ para ~b~%s~s~ a ~y~%s~s~',
  ['gave_weapon_withammo'] = 'diste ~b~%s~s~ con ~o~%sx %s~s~ a ~y~%s~s~',
  ['gave_weapon_hasalready'] = '~y~%s~s~ ya tiene un ~y~%s~s~',
  ['gave_weapon_noweapon'] = '~y~%s~s~ no tiene esa arma',
  ['received_weapon'] = 'recibiste ~b~%s~s~ de ~b~%s~s~',
  ['received_weapon_ammo'] = 'recibiste ~o~%sx %s~s~ para tu ~b~%s~s~ de ~b~%s~s~',
  ['received_weapon_withammo'] = 'recibiste ~b~%s~s~ con ~o~%sx %s~s~ de ~b~%s~s~',
  ['received_weapon_hasalready'] = '~b~%s~s~ trató de darte una ~y~%s~s~, pero ya tienes una.',
  ['received_weapon_noweapon'] = '~b~%s~s~ trató de darte munición para ~y~%s~s~, pero no tienes esa arma',
  ['gave_account_money'] = 'diste ~g~$%s~s~ (%s) a ~y~%s~s~',
  ['received_account_money'] = 'recibiste ~g~$%s~s~ (%s) de ~b~%s~s~',
  ['amount_invalid'] = 'cantidad inválida',
  ['players_nearby'] = 'no hay jugadores cercanos',
  ['ex_inv_lim'] = 'acción imposible, excede el inventario máximo de ~y~%s~s~',
  ['imp_invalid_quantity'] = 'acción imposible, cantidad inválida',
  ['imp_invalid_amount'] = 'acción imposible, monto inválido',
  ['threw_standard'] = 'has tirado ~y~%sx~s~ ~b~%s~s~',
  ['threw_account'] = 'has tirado ~g~$%s~s~ ~b~%s~s~',
  ['threw_weapon'] = 'has tirado ~b~%s~s~',
  ['threw_weapon_ammo'] = 'has tirado ~b~%s~s~ con ~o~%sx %s~s~',
  ['threw_weapon_already'] = 'ya estás llevando esa arma',
  ['threw_cannot_pickup'] = 'No puedes recoger eso porque tu inventario ya está lleno!',
  ['threw_pickup_prompt'] = 'presiona ~y~E~s~ para recoger',

  -- Key mapping
  ['keymap_showinventory'] = 'ver Inventario',

  -- Salary related
  ['received_salary'] = 'Has recibido tu salario: ~g~$%s~s~',
  ['received_help'] = 'Has recibido tu ayuda del estado: ~g~$%s~s~',
  ['company_nomoney'] = 'La compañía para la cuál estás trabajando es muy pobre para pagar tu salario',
  ['received_paycheck'] = 'Has recibido tu pago',
  ['bank'] = 'Banco',
  ['account_bank'] = 'banco',
  ['account_black_money'] = 'dinero sucio',
  ['account_money'] = 'efectivo',

  ['act_imp'] = 'No se puede realizar esta acción',
  ['in_vehicle'] = 'no puedes darle nada a alguien que está dentro de un vehículo',

  -- Commands
  ['command_car'] = 'Generar un vehículo',
  ['command_car_car'] = 'Nombre o hash del vehículo',
  ['command_cardel'] = 'Borrar vehículos cercanos',
  ['command_cardel_radius'] = 'opcional, borrar los vehículos dentro de un radio',
  ['command_clear'] = 'borrar chat',
  ['command_clearall'] = 'borrar chat para todos los usuarios',
  ['command_clearinventory'] = 'borrar inventario',
  ['command_clearloadout'] = 'borrar armamento',
  ['command_giveaccountmoney'] = 'entregar dinero en cuenta',
  ['command_giveaccountmoney_account'] = 'nombre de cuenta válido',
  ['command_giveaccountmoney_amount'] = 'monto a agregar',
  ['command_giveaccountmoney_invalid'] = 'cuenta inválida',
  ['command_giveitem'] = 'entregar un item a un usuario',
  ['command_giveitem_item'] = 'nombre del item',
  ['command_giveitem_count'] = 'cantidad del item',
  ['command_giveweapon'] = 'dar un arma a un usuario',
  ['command_giveweapon_weapon'] = 'nombre del arma',
  ['command_giveweapon_ammo'] = 'cantidad de munición',
  ['command_giveweapon_hasalready'] = 'el jugador ya tiene esa arma',
  ['command_giveweaponcomponent'] = 'entregar componente de arma',
  ['command_giveweaponcomponent_component'] = 'nombre del componente',
  ['command_giveweaponcomponent_invalid'] = 'componente inválido',
  ['command_giveweaponcomponent_hasalready'] = 'el jugador ya tiene dicho componente',
  ['command_giveweaponcomponent_missingweapon'] = 'el jugador no tiene esa arma',
  ['command_save'] = 'guardar un usuario',
  ['command_saveall'] = 'guardar todos los usuarios en la base de datos',
  ['command_setaccountmoney'] = 'establecer el dinero en cuenta de un usuario',
  ['command_setaccountmoney_amount'] = 'cantidad de dinero a establecer',
  ['command_setcoords'] = 'teletransportarse a unas coordenadas',
  ['command_setcoords_x'] = 'eje x',
  ['command_setcoords_y'] = 'eje y',
  ['command_setcoords_z'] = 'eje z',
  ['command_setjob'] = 'configurar trabajo de un usuario',
  ['command_setjob_job'] = 'nombre del trabajo',
  ['command_setjob_grade'] = 'posición del trabajo',
  ['command_setjob_invalid'] = 'el trabajo, la posición o la combinación de ambos son inválidos',
  ['command_setgroup'] = 'cambiar grupo del usuario',
  ['command_setgroup_group'] = 'nombre del grupo',
  ['commanderror_argumentmismatch'] = 'cantidad de argumentos inválidos (recibidos %s, se esperaban %s)',
  ['commanderror_argumentmismatch_number'] = 'el tipo de dato para #%s no es válido (recibido texto, se esperaba número)',
  ['commanderror_invaliditem'] = 'nombre del item inválido',
  ['commanderror_invalidweapon'] = 'nombre del arma inválida',
  ['commanderror_console'] = 'ese comando no se puede ejecutar desde la consola',
  ['commanderror_invalidcommand'] = '^3%s^0 no es un comando válido!',
  ['commanderror_invalidplayerid'] = 'no hay ningún usuario online con ese id',
  ['commandgeneric_playerid'] = 'id de jugador',

  -- Locale settings
  ['locale_digit_grouping_symbol'] = ',',
  ['locale_currency'] = '$%s',

  -- Weapons
  ['weapon_knife'] = 'cuchillo',
  ['weapon_nightstick'] = 'porra',
  ['weapon_hammer'] = 'martillo',
  ['weapon_bat'] = 'bate de béisbol',
  ['weapon_golfclub'] = 'palo de golf',
  ['weapon_crowbar'] = 'palanca',
  ['weapon_pistol'] = 'pistola',
  ['weapon_combatpistol'] = 'pistola de combate',
  ['weapon_appistol'] = 'pistola perforante',
  ['weapon_pistol50'] = 'pistola de calibre 50',
  ['weapon_microsmg'] = 'microsubfusil',
  ['weapon_smg'] = 'subfusil',
  ['weapon_assaultsmg'] = 'subfusil de asalto',
  ['weapon_assaultrifle'] = 'fusil de asalto',
  ['weapon_carbinerifle'] = 'carabina',
  ['weapon_advancedrifle'] = 'fusil avanzado',
  ['weapon_mg'] = 'ametralladora',
  ['weapon_combatmg'] = 'ametralladora de combate',
  ['weapon_pumpshotgun'] = 'escopeta de corredera',
  ['weapon_sawnoffshotgun'] = 'escopeta recortada',
  ['weapon_assaultshotgun'] = 'escopeta de asalto',
  ['weapon_bullpupshotgun'] = 'escopeta bullpup',
  ['weapon_stungun'] = 'pistola eléctrica',
  ['weapon_sniperrifle'] = 'fusil de francotirador',
  ['weapon_heavysniper'] = 'fusil de francotirador pesado',
  ['weapon_grenadelauncher'] = 'lanzagranadas',
  ['weapon_rpg'] = 'lanzacohetes',
  ['weapon_minigun'] = 'ametralladora rotatoria',
  ['weapon_grenade'] = 'granada',
  ['weapon_stickybomb'] = 'bomba adhesiva',
  ['weapon_smokegrenade'] = 'gas lacrimógeno',
  ['weapon_bzgas'] = 'gas BZ',
  ['weapon_molotov'] = 'cóctel molotov',
  ['weapon_fireextinguisher'] = 'extintor',
  ['weapon_petrolcan'] = 'bidón de gasolina',
  ['weapon_ball'] = 'pelota',
  ['weapon_snspistol'] = 'pistola cutre',
  ['weapon_bottle'] = 'botella',
  ['weapon_gusenberg'] = 'gusenberg sweeper',
  ['weapon_specialcarbine'] = 'carabina especial',
  ['weapon_heavypistol'] = 'pistola pesada',
  ['weapon_bullpuprifle'] = 'fusil bullpup',
  ['weapon_dagger'] = 'puñal de caballería',
  ['weapon_vintagepistol'] = 'pistola vintage',
  ['weapon_firework'] = 'cañón de pirotecnia',
  ['weapon_musket'] = 'mosquete',
  ['weapon_heavyshotgun'] = 'escopeta pesada',
  ['weapon_marksmanrifle'] = 'fusil de tirador',
  ['weapon_hominglauncher'] = 'lanzacohetes guiado',
  ['weapon_proxmine'] = 'mina de proximidad',
  ['weapon_snowball'] = 'bola de nieve',
  ['weapon_flaregun'] = 'pistola de bengalas',
  ['weapon_combatpdw'] = 'ADP de combate',
  ['weapon_marksmanpistol'] = 'pistola de tirador',
  ['weapon_knuckle'] = 'puño americano',
  ['weapon_hatchet'] = 'hacha',
  ['weapon_railgun'] = 'fusil electromagnético',
  ['weapon_machete'] = 'machete',
  ['weapon_machinepistol'] = 'pistola ametralladora',
  ['weapon_switchblade'] = 'navaja',
  ['weapon_revolver'] = 'revólver pesado',
  ['weapon_dbshotgun'] = 'escopeta de dos cañones',
  ['weapon_compactrifle'] = 'fusil compacto',
  ['weapon_autoshotgun'] = 'escopeta sweeper',
  ['weapon_battleaxe'] = 'hacha de combate',
  ['weapon_compactlauncher'] = 'lanzagranadas compacto',
  ['weapon_minismg'] = 'minisubfusil',
  ['weapon_pipebomb'] = 'bomba casera',
  ['weapon_poolcue'] = 'taco de billar',
  ['weapon_wrench'] = 'llave grifa',
  ['weapon_flashlight'] = 'linterna',
  ['gadget_parachute'] = 'paracaidas',
  ['weapon_flare'] = 'bengala',
  ['weapon_doubleaction'] = 'revólver de doble acción',

   -- Weapon Components
   ['component_clip_default'] = 'clip standar',
   ['component_clip_extended'] = 'clip extendido',
   ['component_clip_drum'] = 'tambor giratorio',
   ['component_clip_box'] = 'caja de munición',
   ['component_flashlight'] = 'linterna',
   ['component_scope'] = 'alcance',
   ['component_scope_advanced'] = 'alcance avanzado',
   ['component_suppressor'] = 'silenciador',
   ['component_grip'] = 'empuñadura',
   ['component_luxary_finish'] = 'acabado de lujo',
 
   -- Weapon Ammo
   ['ammo_rounds'] = 'bala(s)',
   ['ammo_shells'] = 'cartucho(s)',
   ['ammo_charge'] = 'carga',
   ['ammo_petrol'] = 'ml de gasolina',
   ['ammo_firework'] = 'fuego(s) articifial(es)',
   ['ammo_rockets'] = 'cohete(s)',
   ['ammo_grenadelauncher'] = 'granada(s)',
   ['ammo_grenade'] = 'granada(s)',
   ['ammo_stickybomb'] = 'bomba(s)',
   ['ammo_pipebomb'] = 'bomba(s)',
   ['ammo_smokebomb'] = 'bomba(s)',
   ['ammo_molotov'] = 'cóctel(es)',
   ['ammo_proxmine'] = 'mina(s)',
   ['ammo_bzgas'] = 'lata(s)',
   ['ammo_ball'] = 'bola(s)',
   ['ammo_snowball'] = 'bola(s) de nieve',
   ['ammo_flare'] = 'bengala(s)',
   ['ammo_flaregun'] = 'bengala(s)',
 
   -- Weapon Tints
   ['tint_default'] = 'apariencia predeterminada',
   ['tint_green'] = 'apariencia verde',
   ['tint_gold'] = 'apariencia dorada',
   ['tint_pink'] = 'apariencia rosa',
   ['tint_army'] = 'apariencia militar',
   ['tint_lspd'] = 'apariencia azul',
   ['tint_orange'] = 'apariencia naranja',
   ['tint_platinum'] = 'apariencia platino',
}
