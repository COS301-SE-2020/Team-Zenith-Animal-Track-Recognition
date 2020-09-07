import { FormBuilder, FormGroup } from '@angular/forms';
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
  fileToUpload: File = null;
  textAreaInput: string;
  disabled: true;
  addAnimalImage: FormGroup;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any,
    private http: HttpClient,
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<AddImageComponent>) { }

  ngOnInit(): void {
    this.addAnimalImage = this.formBuilder.group({
      animalID: [this.data.animal.animalID],
      commonName: [this.data.animal.commonName],
      classification: [this.data.animal.classification],
      animalDescription: [this.data.animal.animalDescription]
    });
  }

  onSubmit(test: boolean) {
    if (false === test) {
      //this.startLoader();

      let base64;
      let reader = new FileReader();
      reader.readAsDataURL(this.fileToUpload);
      reader.onload = () => {
        base64 = reader.result;
      };

      this.http.post<any>(ROOT_QUERY_STRING + '?mutation{addIMG64ToAnilmil(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
        '",IMG64:"' + base64 + '",animalID:"' + this.data.animal.animalID + '")}', '').subscribe({
          next: data => this.dialogRef.close("success"),
          error: error => this.dialogRef.close("error")
        });
    }
  }

  closeDialog() {
    this.dialogRef.close("cancel");
  }

  get f() {
    return this.addAnimalImage.controls;
  }

  uploadFile(event: FileList) {
    this.fileToUpload = event.item(0)
    this.files.push(this.fileToUpload.name);
  }

  deleteAttachment(index) {
    this.files.splice(index, 1)
  }

  attachProgressbar() {
    //Append progress bar to dialog
    let matDialog = document.getElementById('add-image-dialog');
    let progressBar = document.getElementById("dialog-progressbar-container");
    matDialog.insertBefore(progressBar, matDialog.firstChild);
  }
  //Loader - Progress bar
  startLoader() {
    //this.attachProgressbar();
    document.getElementById("dialog-progressbar-container").style.visibility = "visible";
  }
  stopLoader() {
    document.getElementById("dialog-progressbar-container").style.visibility = "hidden";
  }
}
