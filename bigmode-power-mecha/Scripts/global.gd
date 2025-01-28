extends Node

#photon cannon properties
var photon_cooldown: float = 0.5
var photon_damage: int = 40

#laser miner properties
var laser_damage: int = 20

#here are variables for collectibles, daynight cycle perhaps
var collected_ore: int = 0
var max_ore_collected: int = 25

var deposited_ore: int = 0
var deposit_time_tick: float = 0.05 #depo time second per ore

var number_of_batteries: int = 1
var max_base_charge: int = 100 * number_of_batteries
var current_base_charge: int = 50
