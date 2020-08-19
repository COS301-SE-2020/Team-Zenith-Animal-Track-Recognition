import { Component, OnInit, ViewChild , Input } from '@angular/core';
import { MatAccordion } from '@angular/material/expansion';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { NgbActiveModal, NgbModal } from '@ng-bootstrap/ng-bootstrap';

export interface Permissions {
	permission: string;
	level1: string;
	level2: string;
	level3: string;
}

const PERMISSIONS: Permissions[] = [
	{ permission: "Spoor Capture & Identification", level1: "1", level2: "1", level3: "1" },
	{ permission: "View Spoor Geotag Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Seach Spoor Geotag Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "View Animal Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Search Animal Information", level1: "1", level2: "1", level3: "1" },
	{ permission: "Edit Spoor Information", level1: "0", level2: "1", level3: "1" },
	{ permission: "Add Animal Information", level1: "0", level2: "0", level3: "1" },
	{ permission: "Edit Animal Information", level1: "0", level2: "0", level3: "1" },
];
@Component({
  selector: 'app-personal-ranger-permission-component',
  templateUrl: './personal-ranger-permission-component.component.html',
  styleUrls: ['./personal-ranger-permission-component.component.css']
})

export class PersonalRangerPermissionComponentComponent implements OnInit {

	@ViewChild(MatAccordion) accordion: MatAccordion;
  @Input() name;

  permissionsColumns: string[] = ['Permissions', 'Level 1 Rangers', 'Level 2 Rangers', 'Level 3 Rangers'];
	permissionsDataSource = PERMISSIONS;
  
	constructor(public activeModal: NgbActiveModal) {}


  ngOnInit(): void {

		PERMISSIONS.forEach(function (perm) {
			if (perm.level1 == "1")
				perm.level1 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level1 == "0")
				perm.level1 = "<span class='material-icons notAllowed'>cancel</span>";

			if (perm.level2 == "1")
				perm.level2 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level2 == "0")
				perm.level2 = "<span class='material-icons notAllowed'>cancel</span>";

			if (perm.level3 == "1")
				perm.level3 = "<span class='material-icons allowed'>check_circle</span>";
			else if (perm.level3 == "0")
				perm.level3 = "<span class='material-icons notAllowed'>cancel</span>";
		});

  }

  onSubmit(test: boolean){

  }
}
