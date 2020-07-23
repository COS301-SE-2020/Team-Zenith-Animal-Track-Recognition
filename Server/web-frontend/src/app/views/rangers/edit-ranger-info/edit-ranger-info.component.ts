import { Component, OnInit, Inject } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA} from '@angular/material/dialog'; 

@Component({
  selector: 'app-edit-ranger-info',
  templateUrl: './edit-ranger-info.component.html',
  styleUrls: ['./edit-ranger-info.component.css']
})
export class EditRangerInfoComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit(): void {
  }

}
