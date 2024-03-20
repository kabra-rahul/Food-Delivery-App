<?php

namespace App\Admin\Controllers;

use App\Models\Zone;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Grimzy\LaravelMysqlSpatial\SpatialServiceProvider;

class ZoneController extends AdminController
{
        /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Zone';

     /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Zone());

        $grid->column('id', __('Zone Id'))->sortable();
        //$grid->id("User Id")->sortable(); is same as above as id() creates a function
        $grid->column('name', __('Name'));
        $grid->column('coordinates',__('Co-ordinates'));
        $grid->column('status', __('Status'));
        $grid->column('created_at', __('Created At'));
        $grid->column('updated_at', __('Updated At'));

        return $grid;
    }

    protected function detail($id)
    {
        $show = new Show(Zone::findOrFail($id));

        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Zone());

        $form->text('name', __('Name'));
        $form->map('45.51563', '-122.677433', 'Co-ordinates')->useGoogleMap();
       // $form->polygon('coordinates',__('Co-ordinates'));
        $form->email('email', __('Email'));
        $form->datetime('email_verified_at', __('Email verified at'))->default(date('Y-m-d H:i:s'));
        $form->password('password', __('Password'));
        $form->text('remember_token', __('Remember token'));

        return $form;
    }
}