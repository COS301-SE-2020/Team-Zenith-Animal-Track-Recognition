import { HttpClient } from '@angular/common/http';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ROOT_QUERY_STRING } from 'src/app/models/data';

@Component({
	selector: 'app-edit-animal-info',
	templateUrl: './edit-animal-info.component.html',
	styleUrls: ['./edit-animal-info.component.css']
})
export class EditAnimalInfoComponent implements OnInit {

	test: boolean = false;
	testString: string;
	editAnimalForm: FormGroup;
	diet: string;
	//DUMMY DATA
	dietTypeList: string[];

	constructor(
		@Inject(MAT_DIALOG_DATA) public data: any,
		private http: HttpClient,
		private formBuilder: FormBuilder,
		public dialogRef: MatDialogRef<EditAnimalInfoComponent>) { }

	ngOnInit(): void {

		if (this.test == true) {
			return;
		}

		this.fillDietTypes();

		const fheight: string = this.data.animal.heightF;
		if (fheight.indexOf('-') > 0) {
			this.data.animal.heightFLB = Number.parseFloat(fheight.substring(0, fheight.indexOf('-')));
			this.data.animal.heightFUB = Number.parseFloat(fheight.substring(fheight.indexOf('-') + 1));
		} else {
			this.data.animal.heightFLB = this.data.animal.heightFUB = Number.parseFloat(fheight);
		}
		const mheight: string = this.data.animal.heightM;
		if (mheight.indexOf('-') > 0) {
			this.data.animal.heightMLB = Number.parseFloat(mheight.substring(0, mheight.indexOf('-')));
			this.data.animal.heightMUB = Number.parseFloat(mheight.substring(mheight.indexOf('-') + 1));
		} else {
			this.data.animal.heightMLB = this.data.animal.heightMUB = Number.parseFloat(mheight);
		}
		const fweight: string = this.data.animal.weightF;
		if (fweight.indexOf('-') > 0) {
			this.data.animal.weightFLB = Number.parseFloat(fweight.substring(0, fweight.indexOf('-')));
			this.data.animal.weightFUB = Number.parseFloat(fweight.substring(fweight.indexOf('-') + 1));
		} else {
			this.data.animal.weightFLB = this.data.animal.weightFUB = Number.parseFloat(fweight);
		}
		const mweight: string = this.data.animal.weightM;
		if (mweight.indexOf('-') > 0) {
			this.data.animal.weightMLB = Number.parseFloat(mweight.substring(0, mweight.indexOf('-')));
			this.data.animal.weightMUB = Number.parseFloat(mweight.substring(mweight.indexOf('-') + 1));
		} else {
			this.data.animal.weightMLB = this.data.animal.weightMUB = Number.parseFloat(mweight);
		}

		setTimeout(() => {
			if (this.dietTypeList.includes(this.data.animal.dietType) == false) {
				this.data.animal.dietType = "Not Specified";
			}
		}, 1000);


		this.editAnimalForm = this.formBuilder.group({
			commonName: [this.data.animal.commonName],
			classification: [this.data.animal.classification],
			animalDescription: [this.data.animal.animalDescription],
			heightFLB: [this.data.animal.heightFLB],
			heightFUB: [this.data.animal.heightFUB],
			heightMLB: [this.data.animal.heightMLB],
			heightMUB: [this.data.animal.heightMUB],
			weightFLB: [this.data.animal.weightFLB],
			weightFUB: [this.data.animal.weightFUB],
			weightMLB: [this.data.animal.weightMLB],
			weightMUB: [this.data.animal.weightMUB],
			gestationPeriod: [this.data.animal.gestationPeriod],
			numOffspring: [Number.parseInt(this.data.animal.Offspring)],
			lifeSpan: [this.data.animal.lifeSpan],
			dietType: [this.data.animal.dietType],
			femaleBehaviour: [this.data.animal.typicalBehaviourF['behaviour']],
			maleBehaviour: [this.data.animal.typicalBehaviourM['behaviour']],
			habitatDescrip: [''],
			habitatFeatures: [''],
			femaleThreat: [this.data.animal.typicalBehaviourF['threatLevel']],
			maleThreat: [this.data.animal.typicalBehaviourF['threatLevel']]
		});
		document.getElementById('edit-animal-dialog').style.overflow = "hidden";
	}

	fillDietTypes() {
		if (this.test == true) {
			return;
		} else {
			this.http.get<any>(ROOT_QUERY_STRING + '?query=query{dietType(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] + '")}')
				.subscribe((data: any[]) => {
					let temp = [];
					temp = Object.values(data)[0]['dietType'];
					this.dietTypeList = temp;
				});
		}
	}

	get f() {
		if (this.test == true) {
			return {};
		}
		return this.editAnimalForm.controls;
	}

	onSubmit(test: boolean) {
		if (false === test) {
			let heightF, heightM, weightF, weightM;
			heightF = this.f.heightFLB.value + "-" + this.f.heightFUB.value;
			heightM = this.f.heightMLB.value + "-" + this.f.heightMUB.value;
			weightF = this.f.weightFLB.value + "-" + this.f.weightFUB.value;
			weightM = this.f.weightMLB.value + "-" + this.f.weightMUB.value;

			this.startLoader();

			const desc: string = this.remQuotes(('' + this.f.animalDescription.value));
			const mb: string = this.remQuotes(('' + this.f.maleBehaviour.value));
			const fb: string = this.remQuotes(('' + this.f.femaleBehaviour.value));
			const mt: string = this.remQuotes(('' + this.f.maleThreat.value));
			const ft: string = this.remQuotes(('' + this.f.femaleThreat.value));

			this.http.post<any>(ROOT_QUERY_STRING + '?query=mutation{' +
				'updateAnimal(token:"' + encodeURIComponent(JSON.parse(localStorage.getItem('currentToken'))['value']) +
				'",classification:"' + encodeURIComponent(this.f.classification.value) +
				'",commonName:"' + encodeURIComponent(this.f.commonName.value) +
				'",lifeSpan:"' + encodeURIComponent(this.f.lifeSpan.value) +
				'",animalDescription:"' + encodeURIComponent(desc) +
				'",heightF:"' + encodeURIComponent(heightF) +
				'",heightM:"' + encodeURIComponent(heightM) +
				'",weightM:"' + encodeURIComponent(weightM) +
				'",weightF:"' + encodeURIComponent(weightF) +
				'",dietType:"' + encodeURIComponent(this.f.dietType.value) +
				'",gestationPeriod:"' + encodeURIComponent(this.f.gestationPeriod.value) +
				'",Offspring:"' + encodeURIComponent(this.f.numOffspring.value > 0 ? this.f.numOffspring.value : 1) +
				'",typicalBehaviourM:"' + encodeURIComponent(mb) +
				'",typicalBehaviourF:"' + encodeURIComponent(fb) +
				'",typicalThreatLevelM:"' + encodeURIComponent(mt) +
				'",typicalThreatLevelF:"' + encodeURIComponent(ft) +
				'"){animalID}}', '')
				.subscribe({
					next: data => this.dialogRef.close('success'),
					error: error => this.dialogRef.close('error')
				});
		}
		else {
			return true;
		}
	}

	remQuotes(word: string) {
		while (word.includes('"')) {
			word = word.replace('"', '\'');
		}
		return word;
	}

	closeDialog() {
		if(this.test == true){
			return;
		}
		this.dialogRef.close("cancel");
	}

	attachProgressbar() {
		if(this.test == true){
			return;
		}
		//Append progress bar to dialog
		let matDialog = document.getElementById('edit-animal-dialog');
		let progressBar = document.getElementById("dialog-progressbar-container");
		matDialog.insertBefore(progressBar, matDialog.firstChild);
	}

	//Loader - Progress bar
	startLoader() {
		if(this.test == true){
			return;
		}
		this.attachProgressbar();
		document.getElementById("dialog-progressbar-container").style.visibility = "visible";
	}
	stopLoader() {
		if(this.test == true){
			return;
		}
		document.getElementById("dialog-progressbar-container").style.visibility = "hidden";
	}
}