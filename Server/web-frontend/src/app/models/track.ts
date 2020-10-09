import { Animal } from './animal';
import { DateAndTime } from './datetime';
import { PotentialMatch } from './potential-match';
import { Picture } from './picture';
import { User } from './user';

export interface Track
{
	spoorIdentificationID?: string;
	animal?: Animal;
	dateAndTime?: DateAndTime;
	recency?: string;
	dateObj?: any;
	location: {
		latitude?: number;
		longitude?: number;
		addresses?: any[];
	}
	marker?: any;
	ranger?: User;
	potentialMatches?: PotentialMatch[];
	picture?: Picture;
	tags?: String[];
	similar?: Picture[];
}
