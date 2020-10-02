import { Animal } from './animal';


export interface PotentialMatch
{
	animal?: Animal;
	confidence?: number;
}