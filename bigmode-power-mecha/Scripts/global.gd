extends Node

#photon cannon properties
var photon_cooldown: float = 0.4
var photon_damage: int = 40

#laser miner properties, not used
var laser_damage: int = 20

#here are variables for collectibles, daynight cycle perhaps
var collected_ore: int = 0
var max_ore_collected: int = 300

var deposited_ore: int = 0
var deposit_time_tick: float = 0.05 #depo time second per ore

var number_of_batteries: int = 0
var max_base_charge: int = 100 * number_of_batteries
var current_base_charge: int = 300
var recharge_time_tick: float = 0.05 #1 charge gain second

var enemy_count: int = 0

#VARIABLES FOR LEVELUP
var exp_collected: int = 0
var exp_for_next_level: float = 150.0
var current_level: int = 1



	
