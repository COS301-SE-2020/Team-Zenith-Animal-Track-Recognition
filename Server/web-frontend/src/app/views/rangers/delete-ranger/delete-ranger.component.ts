import { Component, OnInit } from '@angular/core';
import {MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA} from '@angular/material/dialog'; 

@Component({
  selector: 'app-delete-ranger',
  templateUrl: './delete-ranger.component.html',
  styleUrls: ['./delete-ranger.component.css']
})
export class DeleteRangerComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit(): void {
  }

}
