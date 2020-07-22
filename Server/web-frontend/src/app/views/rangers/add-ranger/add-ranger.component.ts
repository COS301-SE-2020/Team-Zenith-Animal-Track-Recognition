import { Component, OnInit } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig} from '@angular/material/dialog'; 
import {MatDatepickerModule} from '@angular/material/datepicker';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'app-add-ranger',
  templateUrl: './add-ranger.component.html',
  styleUrls: ['./add-ranger.component.css']
})
export class AddRangerComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

}
