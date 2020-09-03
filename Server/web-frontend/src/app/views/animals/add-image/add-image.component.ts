import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-add-image',
  templateUrl: './add-image.component.html',
  styleUrls: ['./add-image.component.css']
})
export class AddImageComponent implements OnInit {

  files: any = [];
  textAreaInput: string;
  disabled: true;
  constructor(@Inject(MAT_DIALOG_DATA) public data: any,private http: HttpClient,public dialogRef: MatDialogRef<AddImageComponent>) { }

  ngOnInit(): void {
  }

  onSubmit(test:boolean){
    if(false === test){
      this.startLoader();
      // this.http.post<any>(ROOT_QUERY_STRING).subscribe({
      //   next: data => this.dialogRef.close("success"), 
      //   error: error => this.dialogRef.close("error")         
      // })
    }
  }

  closeDialog() {
		this.dialogRef.close("cancel");
  }
  

  uploadFile(event) {
    for (let index = 0; index < event.length; index++) {
      const element = event[index];
      this.files.push(element.name)
    }  
  }
 
  deleteAttachment(index) {
    this.files.splice(index, 1)
  }
  
	attachProgressbar()
	{
		//Append progress bar to dialog
		let matDialog = document.getElementById('add-image-dialog');
		let progressBar = document.getElementById("dialog-progressbar-container");
		matDialog.insertBefore(progressBar, matDialog.firstChild);
	}
	//Loader - Progress bar
	startLoader() {
		this.attachProgressbar();
		document.getElementById("dialog-progressbar-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("dialog-progressbar-container").style.visibility = "hidden";
	}
}
