import { CustomizedWeapon } from "./CustomizedWeapon";
import { Weapon } from "./Weapon";

export interface Loadout {
  primary: CustomizedWeapon;
  secondary: CustomizedWeapon | undefined;
  accessories: Weapon[] | undefined;
}