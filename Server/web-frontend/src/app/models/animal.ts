import { Picture } from './picture';
import { Group } from './animal-group';


export interface Animal
{
	classification?: string;
	animalID?: string;
	commonName?: string;
	groupID?: Group[];
	heightM?: string;
	heightF?: string;
	weightM?: string;
	weightF?: string;
	habitats: {
		habitatID?: number,
		habitatName?: string,
		description?: String,
		distinguishingFeatures?: string
	};
	dietType?: string;
	lifeSpan?: string;
	offspring?: string;
	gestationPeriod?: string;
	typicalBehaviourM: {
		behaviour?: string,
		threatLevel?: string
	};
	typicalBehaviourF: {
		behaviour?: string,
		threatLevel?: string
	};
	animalOverview?: string;
	animalDescription?: string;
	pictures?: Picture[];
	animalMarkerColor?: string;
}
