import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import {MatAccordion} from '@angular/material/expansion';


export interface Permissions 
{
  permission: string;
  level1: string;
  level2: string;
  level3: string;
}

export interface RangerPermissions 
{
  firstName: string;
  lastName: string;
  level1: string;
  level2: string;
  level3: string;
  assignedLevel: number;
}

//Default Ranger Permissions  
const PERMISSIONS: Permissions[] = [
  {permission: "Spoor Capture & Identification", level1: "1", level2: "1", level3: "1"},
  {permission: "View Spoor Geotag Information", level1: "1", level2: "1", level3: "1"},
  {permission: "Seach Spoor Geotag Information", level1: "1", level2: "1", level3: "1"},
  {permission: "View Animal Information", level1: "1", level2: "1", level3: "1"},
  {permission: "Search Animal Information", level1: "1", level2: "1", level3: "1"},
  {permission: "Edit Spoor Information", level1: "0", level2: "1", level3: "1"},
  {permission: "Add Animal Information", level1: "0", level2: "0", level3: "1"},
  {permission: "Edit Animal Information", level1: "0", level2: "0", level3: "1"},
];

const RANGER_PERMISSIONS: RangerPermissions[] = [
	{firstName: "Ameerah", lastName: "Alvarado", level1: "0", level2: "1", level3: "0", assignedLevel: 2},		
	{firstName: "Caroline", lastName: "Arias", level1: "1", level2: "0", level3: "0", assignedLevel: 1},		
	{firstName: "Fletcher", lastName: "Arroyo", level1: "0", level2: "1", level3: "0", assignedLevel: 2},		
	{firstName: "Priscilla", lastName: "Berlein", level1: "0", level2: "0", level3: "1", assignedLevel: 3},		
	{firstName: "Charles", lastName: "de Clarke", level1: "0", level2: "1", level3: "0", assignedLevel: 2},		
	{firstName: "Matthew", lastName: "Deleon", level1: "1", level2: "0", level3: "0", assignedLevel: 1},
	{firstName: "Sibusiso", lastName: "Nxolela", level1: "0", level2: "1", level3: "0", assignedLevel: 2},
	{firstName: "Kagiso", lastName: "Ndlovu", level1: "0", level2: "1", level3: "0", assignedLevel: 2},	
	{firstName: "Daniel", lastName: "Rogers", level1: "0", level2: "0", level3: "1", assignedLevel: 3},	
	{firstName: "Vincent", lastName: "Mataruse", level1: "1", level2: "0", level3: "0", assignedLevel: 1},	
	{firstName: "Tendai", lastName: "Soweto",  level1: "0", level2: "1", level3: "0", assignedLevel: 2},	
];

@Component({
  selector: 'app-ranger-permissions',
  templateUrl: './ranger-permissions.component.html',
  styleUrls: ['./ranger-permissions.component.css']
})
export class RangerPermissionsComponent implements OnInit {
	
	@ViewChild(MatAccordion) accordion: MatAccordion;
  permissionsColumns: string[] = ['Permissions', 'Level 1 Rangers', 'Level 2 Rangers', 'Level 3 Rangers'];
  permissionsDataSource = PERMISSIONS;  
  rangerPermissionsColumns: string[] = ['Ranger', 'Level 1 Ranger', 'Level 2 Ranger', 'Level 3 Ranger', 'Assigned Level'];
  rangerPermissionsDataSource = RANGER_PERMISSIONS;
  
  constructor(private router: Router) { }
 
  ngOnInit(): void 
  {
	document.getElementById("rangers-route").classList.add("activeRoute");
	
	//Replace Permissions with appropiate icon
	PERMISSIONS.forEach(function (perm)
	{
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
	
	var count = 1;
	//Replace Permissions with appropiate radio button
	RANGER_PERMISSIONS.forEach(function (ranger)
	{
		if (ranger.level1 == "1")
			ranger.level1 = "true";
		else if (ranger.level1 == "0")
			ranger.level1 = "false";		
		
		if (ranger.level2 == "1")
			ranger.level2 = "true";
		else if (ranger.level2 == "0")
			ranger.level2 = "false";		
		
		if (ranger.level3 == "1")
			ranger.level3 = "true";
		else if (ranger.level3 == "0")
			ranger.level3 = "false";
		
		count++;
	});
  }
   route(location: string) 
  {
    document.getElementById("animals-route").classList.remove("activeRoute");
    document.getElementById("overview-route").classList.remove("activeRoute");
    document.getElementById("rangers-route").classList.remove("activeRoute");
    document.getElementById("geotags-route").classList.remove("activeRoute");
    document.getElementById("settings-route").classList.remove("activeRoute");
	
    this.router.navigate([location]);
  }

}
