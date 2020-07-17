import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatInputModule} from '@angular/material/input';
import {MatIconModule} from '@angular/material/icon';
import {MatButtonModule} from '@angular/material/button';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './login/login.component';
import { OverviewComponent } from './overview/overview.component';
import { AnimalsComponent } from './animals/animals.component';
import { RangersComponent } from './rangers/rangers.component';
import { GeotagsComponent } from './geotags/geotags.component';
import { SettingsComponent } from './settings/settings.component';
import { SideNavigationComponent } from './side-navigation/side-navigation.component';
import { UtilityNavigationComponent } from './utility-navigation/utility-navigation.component';
import { RangersToolbarComponent } from './rangers-toolbar/rangers-toolbar.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    RangersComponent,
    GeotagsComponent,
    SettingsComponent,
    SideNavigationComponent,
    UtilityNavigationComponent,
    RangersToolbarComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatButtonModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
