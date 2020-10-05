import { MatSnackBar } from '@angular/material/snack-bar';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ROOT_QUERY_STRING } from 'src/app/models/data';
import { HttpClient } from '@angular/common/http';
import * as _ from 'lodash';
import { catchError, retry } from 'rxjs/operators';
import { EMPTY } from 'rxjs';

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
  url;
  imageError: any;
  cardImageBase64: any;
  isImageSaved: boolean;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any,
    private http: HttpClient,
    private formBuilder: FormBuilder,
    public dialogRef: MatDialogRef<AddImageComponent>, 
    private snackBar: MatSnackBar) { }

  ngOnInit(): void {
    this.addAnimalImage = this.formBuilder.group({
      animalID: [this.data.animal.animalID],
      commonName: [this.data.animal.commonName],
      classification: [this.data.animal.classification],
      animalDescription: [this.data.animal.animalDescription]
    });
  }

  onSubmit(test: boolean) {

    //canvas.width = this.fileToUpload.
    if (false === test) {
			this.startLoader();
      this.http.post<any>(ROOT_QUERY_STRING + '?', {
        query:'mutation{addIMG64ToAnilmil(token:"' + JSON.parse(localStorage.getItem('currentToken'))['value'] +
          '",IMG64:"' + this.cardImageBase64 + '",animalID:"' + this.data.animal.animalID + '")}',variables:{}
      })
      .pipe(
				retry(3),
				catchError(() => {
					this.snackBar.open('An error occurred when connecting to the server. Please refresh and try again.', "Dismiss", { duration: 7000, });
					this.stopLoader();
					return EMPTY;
				})
			)
      .subscribe({
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

  uploadFile(event) {
    this.imageError = null;
    if (event.target.files && event.target.files[0]) {
      // Size Filter Bytes
      const max_size = 20971520;
      const allowed_types = ['image/png', 'image/jpeg'];
      const max_height = 15200;
      const max_width = 25600;

      if (event.target.files[0].size > max_size) {
        this.imageError =
          'Maximum size allowed is ' + max_size / 1000 + 'Mb';

        return false;
      }

      if (!_.includes(allowed_types, event.target.files[0].type)) {
        this.imageError = 'Only Images are allowed ( JPG | PNG )';
        return false;
      }
      const reader = new FileReader();
      reader.onload = (e: any) => {
        const image = new Image();
        image.src = e.target.result;
        image.onload = rs => {
          const img_height = rs.currentTarget['height'];
          const img_width = rs.currentTarget['width'];

          console.log(img_height, img_width);


          if (img_height > max_height && img_width > max_width) {
            this.imageError =
              'Maximum dimentions allowed ' +
              max_height +
              '*' +
              max_width +
              'px';
            return false;
          } else {
            const imgBase64Path = e.target.result;
            this.cardImageBase64 = ('' + imgBase64Path).replace('data:image/jpeg;base64,', '').replace('data:image/png;base64,','');
            this.isImageSaved = true;
            // this.previewImagePath = imgBase64Path;
          }
        };
      };

      reader.readAsDataURL(event.target.files[0]);
    }
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
		this.attachProgressbar();
		document.getElementById("dialog-progressbar-container").style.visibility = "visible";
	}
	stopLoader() {
		document.getElementById("dialog-progressbar-container").style.visibility = "hidden";
	}
}
