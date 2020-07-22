import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-add-ranger',
  templateUrl: './add-ranger.component.html',
  styleUrls: ['./add-ranger.component.css']
})
export class AddRangerComponent implements OnInit {
  addUserForm: FormGroup;
  loading = false;
  submitted = false;

  hide = true;
  constructor(
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {
  }

  ngOnInit(): void {
    this.addUserForm = this.formBuilder.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', Validators.required],
      phoneNumber: ['', Validators.required],
      dob: ['', Validators.required]
    });
  }

  get f() { return this.addUserForm.controls; }

  onSubmit() {
    this.submitted = true;

    if (this.addUserForm.invalid) {
      return;
    }

    this.loading = true;
  }


}
