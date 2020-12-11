import { Weapon } from "./Weapon";

export interface CustomizedWeapon {
  weapon: Weapon;
  attachments: string[] | undefined;
}